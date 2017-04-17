#!/bin/bash

CWD=`pwd`

source ~/.topology
source hosts
source routers
source helperFunctions

echo "start nlsr on routers"
echo ${ROUTER_CONFIG}
for s in "${ROUTER_CONFIG[@]}"
do
  router_info=(${s//:/ })
  HOST=${router_info[3]}
  NAME=${router_info[0]}
  echo  "$NAME $HOST: "
  ssh ${!HOST} "ps auxwww | grep nlsr"
  echo ""
done
