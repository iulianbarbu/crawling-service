#!/bin/bash

export NUTCH_HOME=/opt/nutch
export SOLR_INSTALLATION=/opt/solr
export HBASE_HOME=/opt/hbase
export PATH=$PATH:$NUTCH_RUNTIME_HOME/bin:$SOLR_INSTALLATION/bin:$HBASE_HOME/bin

export ORIG_PATH=$PATH

function switchTo41Firefox() {
	PATH=/home/iulian/Licenta/firefox-41.0-x86_64:$ORIG_PATH
}

function switchTo31Firefox() {
	PATH=/home/iulian/Licenta/firefox-31.4.0esr-x86_64:$ORIG_PATH
}

function switchToNewFirefox() {
	PATH=$ORIG_PATH
}
