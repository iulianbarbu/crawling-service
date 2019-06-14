#!/usr/bin/env bash

HADOOP_HOME=/home/nutch/hadoop
NUTCH_HOME=/home/nutch/nutch
SOLR_HOME=/home/solr/solr
ZK_CONF=/home/solr/zookeeper/conf
ZK_HOME=/home/solr/zookeeper
ZK_DATADIR=/home/solr/zookeeper/datadir

function usage() {
    echo "Usage: ./run.sh [--rebuild] [--hnodes=N] [--snodes=N]"
    echo
    echo "--rebuild		Rebuild hadoop and solr"
	echo "--hnodes		Number of hadoop nodes that will be started in the hadoop cluster."
	echo "--snodes		Number of solr nodes that will be started in the solr cluster."
}

function build_hadoop() {
    if [[ $REBUILD -eq 1 || "$(docker images -q hadoop-base)" == "" ]]; then
        #rebuild the base image if not exist
        if [[ "$(docker images -q hadoop-base)" == "" ]]; then
            echo "Building Hadoop...."
			cd /home/iulian/Licenta/
            docker build -t hadoop-base -f Dockerfile_hadoop .
        else
			# remove the outdated image base
			#docker rm -f $(docker rmi $(docker inspect -f='{{index .Id}}' hadoop-base | cut -d ':' -f 2)) 2>&1 > /dev/null
			echo "Building Hadoop...."
			cd /home/iulian/Licenta/
            docker build -t hadoop-base -f Dockerfile_hadoop .
		fi
    fi
}

function build_solr() {
    if [[ $REBUILD -eq 1 || "$(docker images -q solr-base)" == "" ]]; then
        #rebuild the base image if not exist
        if [[ "$(docker images -q solr-base)" == "" ]]; then
            echo "Building Solr...."
			cd /home/iulian/Licenta/
            docker build -t solr-base -f Dockerfile_solr .
        else
			# remove the outdated image base
			echo "Building Solr...."
			cd /home/iulian/Licenta/
            docker build -t solr-base -f Dockerfile_solr .
		fi
    fi
}


function create_hadoop_cluster() {
	#create hadoop cluster network
	docker network create hadoop-cluster-network 2> /dev/null

	# remove the outdated master
	master_id=$(docker ps -a -q -f "name=hadoop-master")
	if [[ ! -z $master_id ]]; then 
		docker rm -f $master_id 2>&1 > /dev/null
	fi
	
	if [[ -z $HADOOP_NODES ]]; then
		HADOOP_NODES=0
	fi

	# launch master container
	master_id=$(docker run -d --shm-size=2g --rm --net hadoop-cluster-network --name hadoop-master hadoop-base)
	echo ${master_id:0:12} > hosts
	for i in $(seq $((HADOOP_NODES-1)));
	do
		container_id=$(docker run -d --shm-size=2g --rm --net hadoop-cluster-network hadoop-base)
		echo "Started $container_id."
		echo ${container_id:0:12} >> hosts
	done

	# Copy the workers file to the master container
	docker cp hosts $master_id:$HADOOP_HOME/etc/hadoop/workers
	docker cp hosts $master_id:$HADOOP_HOME/etc/hadoop/slaves	
	
	rm hosts	

	# Start hdfs and yarn services
	docker exec -it $master_id $HADOOP_HOME/sbin/start-dfs.sh
	docker exec -it $master_id $HADOOP_HOME/sbin/start-yarn.sh
	docker exec -it $master_id $HADOOP_HOME/sbin/mr-jobhistory-daemon.sh start historyserver
	docker exec -it $master_id hdfs dfs -mkdir /solr
	docker exec -it $master_id hdfs dfs -chown -R solr /solr
}

function create_solr_cluster() {
	
	if [ -z "$(docker ps -a | grep hadoop-master)" ]; then
		echo "Hadoop cluster is not started. Please start the hadoop cluster before starting solr cluster."
		exit 1
	fi

	hadoop_master_ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' hadoop-master)

	cd /home/iulian/Licenta
	ZK_CFG="zookeeper-3.5.5/conf/zoo.cfg"
	rm $ZK_CFG &>/dev/null
	cp zookeeper-3.5.5/conf/zoo_sample.cfg $ZK_CFG		

	# remove the outdated master
	master_id=$(docker ps -a -q -f "name=solr-master")
	if [[ ! -z $master_id ]]; then 
		docker rm -f $master_id 2>&1 > /dev/null
	fi

	if [[ -z $SOLR_NODES ]]; then
		SOLR_NODES=1
	fi

	master_id=$(docker run -d --shm-size=2g --rm --net hadoop-cluster-network --name solr-master solr-base)
	echo "server.1=${master_id:0:12}:2888:3888" >> $ZK_CFG	
	containers[0]=${master_id:0:12}
	ZK_HOSTS="${containers[0]}:2181"	
	docker cp $ZK_CFG ${containers[0]}:$ZK_CONF
	docker exec -it ${containers[0]} mkdir $ZK_DATADIR
	docker exec -it ${containers[0]} touch $ZK_DATADIR/myid
	docker exec -it ${containers[0]} /bin/bash -c "echo $((i + 1)) > $ZK_DATADIR/myid"
	docker exec -it ${containers[0]} $ZK_HOME/bin/zkServer.sh start $ZK_CONF/zoo.cfg
			
	for i in $(seq 1 $((SOLR_NODES-1)));
	do
		container_id=$(docker run -d --shm-size=2g --rm --net hadoop-cluster-network solr-base)
		echo "server.$((i + 1))=${container_id:0:12}:2888:3888" >> $ZK_CFG
		containers[$i]=${container_id:0:12}
		ZK_HOSTS="$ZK_HOSTS,${containers[$i]}:2181"
		docker cp $ZK_CFG ${containers[$i]}:$ZK_CONF
		docker exec -it ${containers[$i]} mkdir $ZK_DATADIR
		docker exec -it ${containers[$i]} touch $ZK_DATADIR/myid
		docker exec -it ${containers[$i]} /bin/bash -c "echo $((i + 1)) > $ZK_DATADIR/myid"
		docker exec -it ${containers[$i]} $ZK_HOME/bin/zkServer.sh start $ZK_CONF/zoo.cfg
	done
	
	for i in $(seq 0 $((SOLR_NODES-1)));
	do
		docker exec -it ${containers[$i]} $SOLR_HOME/bin/solr start -Dsolr.directoryFactory=HdfsDirectoryFactory -Dsolr.lock.type=hdfs -Dsolr.hdfs.home=hdfs://$hadoop_master_ip:9000/solr/ -c -z "$ZK_HOSTS"
	done

	# Start solr daemon
	docker exec -it $master_id $SOLR_HOME/bin/solr zk upconfig -n nutch_default -d /home/solr/solr/server/solr/configsets/nutch_default -z ${containers[0]}:2181
	docker exec -it $master_id curl "http://localhost:8983/solr/admin/collections?action=CREATE&name=nutch_collection&numShards=$SOLR_NODES&replicationFactor=$SOLR_NODES&maxShardsPerNode=$SOLR_NODES&collection.configName=nutch_default"

	# Do auxiliary stuff to make solr available from nutch web interface	
	solr_master_ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' solr-master)
	docker exec hadoop-master unzip $NUTCH_HOME/apache-nutch-1.15.job nutch-site.xml -d .
	docker exec hadoop-master /bin/bash -c "cat $NUTCH_HOME/nutch-site.xml | sed 's/<value><\/value>/<value>http:\/\/$solr_master_ip:8983<\/value>/' > nutch-site-aux.xml"
	docker exec hadoop-master rm $NUTCH_HOME/nutch-site.xml
	docker exec hadoop-master mv $NUTCH_HOME/nutch-site-aux.xml $NUTCH_HOME/nutch-site.xml
	docker exec hadoop-master zip $NUTCH_HOME/apache-nutch-1.15.job nutch-site.xml

	docker exec hadoop-master $NUTCH_HOME/bin/nutch startserver -host $hadoop_master_ip &
	docker exec hadoop-master $NUTCH_HOME/bin/nutch webapp &
}

function parse_arguments() {
    while [ "$1" != "" ]; do
        PARAM=`echo $1 | awk -F= '{print $1}'`
        VALUE=`echo $1 | awk -F= '{print $2}'`
        case $PARAM in
            -h | --help)
                usage
                exit
                ;;
            --rebuild)
                REBUILD=1
                ;;
			--hnodes)
				HADOOP_NODES=$VALUE	
				;;
			--snodes)
				SOLR_NODES=$VALUE	
				;;
            *)
                echo "ERROR: unknown parameter \"$PARAM\""
                usage
                exit 1
                ;;
        esac
        shift
    done
}

parse_arguments $@
#build_hadoop
#build_solr
create_hadoop_cluster
create_solr_cluster
