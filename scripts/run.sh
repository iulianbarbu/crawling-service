#!/usr/bin/env bash

HADOOP_HOME=/root/hadoop/

function usage() {
    echo "Usage: ./run.sh hadoop [--rebuild] [--nodes=N]"
    echo
    echo "hadoop       Make running mode to hadoop"
    echo "--rebuild    Rebuild hadoop if in hadoop mode; else reuild spark"
	echo "--nodes	   Number of nodes that will be started in this cluster."
}

function build_hadoop() {
    if [[ $REBUILD -eq 1 || "$(docker images -q hadoop-base)" == "" ]]; then
        #rebuild the base image if not exist
        if [[ "$(docker images -q hadoop-base)" == "" ]]; then
            echo "Building Hadoop...."
			cd /home/iulian/Licenta/
            docker build -t hadoop-base .
        else
			# remove the outdated image base
			#docker rm -f $(docker rmi $(docker inspect -f='{{index .Id}}' hadoop-base | cut -d ':' -f 2)) 2>&1 > /dev/null
			echo "Building Hadoop...."
			cd /home/iulian/Licenta/
            docker build -t hadoop-base .
		fi
    fi
}

function create_cluster() {
	#create hadoop cluster network
	docker network create hadoop-cluster-network 2> /dev/null

	# remove the outdated master
	master_id=$(docker ps -a -q -f "name=hadoop-master")
	if [[ ! -z $master_id ]]; then 
		docker rm -f $master_id 2>&1 > /dev/null
	fi

	if [[ -z $N ]]; then
		N=3
	fi

	# launch master container
	master_id=$(docker run -d --rm --net hadoop-cluster-network --name hadoop-master hadoop-base)
	echo ${master_id:0:12} > hosts
	for i in $(seq $((N-1)));
	do
		container_id=$(docker run -d --rm --net hadoop-cluster-network hadoop-base)
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

	# Connect to the master node
	docker exec -it hadoop-master /bin/bash
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
			--nodes)
				N=$VALUE
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
build_hadoop
create_cluster
