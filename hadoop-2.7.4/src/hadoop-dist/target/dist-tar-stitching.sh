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

                      run tar cf hadoop-2.7.4.tar hadoop-2.7.4
                      run gzip -f hadoop-2.7.4.tar
                      echo
                      echo "Hadoop dist tar available at: /home/iulian/Licenta/hadoop-2.7.4/src/hadoop-dist/target/hadoop-2.7.4.tar.gz"
                      echo