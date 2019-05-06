run() {
                        echo "\$ ${@}"
                        "${@}"
                        res=$?
                        if [ $res != 0 ]; then
                          echo
                          echo "Failed!"
                          echo
                          exit $res
                        fi
                      }

                      ROOT=`cd ../..;pwd`
                      echo
                      echo "Current directory `pwd`"
                      echo
                      run rm -rf hadoop-2.7.4
                      run mkdir hadoop-2.7.4
                      run cd hadoop-2.7.4
                      run cp $ROOT/LICENSE.txt .
                      run cp $ROOT/NOTICE.txt .
                      run cp $ROOT/README.txt .
                      run cp -r $ROOT/hadoop-common-project/hadoop-common/target/hadoop-common-2.7.4/* .
                      run cp -r $ROOT/hadoop-common-project/hadoop-nfs/target/hadoop-nfs-2.7.4/* .
                      run cp -r $ROOT/hadoop-hdfs-project/hadoop-hdfs/target/hadoop-hdfs-2.7.4/* .
                      run cp -r $ROOT/hadoop-hdfs-project/hadoop-hdfs-httpfs/target/hadoop-hdfs-httpfs-2.7.4/* .
                      run cp -r $ROOT/hadoop-common-project/hadoop-kms/target/hadoop-kms-2.7.4/* .
                      run cp -r $ROOT/hadoop-hdfs-project/hadoop-hdfs-nfs/target/hadoop-hdfs-nfs-2.7.4/* .
                      run cp -r $ROOT/hadoop-yarn-project/target/hadoop-yarn-project-2.7.4/* .
                      run cp -r $ROOT/hadoop-mapreduce-project/target/hadoop-mapreduce-2.7.4/* .
                      run cp -r $ROOT/hadoop-tools/hadoop-tools-dist/target/hadoop-tools-dist-2.7.4/* .
                      echo
                      echo "Hadoop dist layout available at: /home/iulian/Licenta/hadoop-2.7.4/src/hadoop-dist/target/hadoop-2.7.4"
                      echo