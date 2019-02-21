#!/bin/bash

export NUTCH_HOME=/opt/nutch
export SOLR_INSTALLATION=/opt/solr
export HBASE_HOME=/opt/hbase
export PATH=$PATH:$NUTCH_RUNTIME_HOME/bin:$SOLR_INSTALLATION/bin:$HBASE_HOME/bin

export ORIG_PATH=$PATH
PATH=/home/iulian/Licenta/firefox-41.0-x86_64:$ORIG_PATH

function switchToOldFirefox() {
	PATH=/home/iulian/Licenta/firefox-41.0-x86_64:$ORIG_PATH
}

function switchToNewFirefox() {
	PATH=$ORIG_PATH
}
