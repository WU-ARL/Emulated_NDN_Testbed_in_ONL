#!/bin/bash

source ~/.topology
source hosts 

PROTO="udp4"
if [ $# -eq 1 ]
then
  PROTO="$1"
fi

CWD=`pwd`

# get nfd running on hosts and 
#  nfd and nlsr running on routers
echo "configuring hosts"
./configVMs.sh ${PROTO}
echo "Configuring routers"
./configRouters.sh ${PROTO}