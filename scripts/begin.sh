#!/bin/bash

export NUTCH_HOME=/home/iulian/Licenta/nutch
export NUTCH_RUNTIME_HOME=$NUTCH_HOME/runtime/local
export SOLR_HOME=/home/iulian/Licenta/solr-7.3.1/server/solr
export SOLR_INSTALLATION_HOME=$SOLR_HOME/../../
export PATH=$PATH:$NUTCH_RUNTIME_HOME/bin:$SOLR_INSTALLATION_HOME/bin

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
