#!/bin/bash

CWD=`pwd`

source ~/.topology
source ../routers

# start nlsr on all of the routers
echo "start nlsr on routers"
echo ${ROUTER_CONFIG}
for s in "${ROUTER_CONFIG[@]}"
do
  router_info=(${s//:/ })
  HOST=${router_info[2]}
  NAME=${router_info[1]}
  echo "startNlsr.sh, nlsr: $NAME on $HOST"
  ssh ${!HOST} "cd $CWD ; nohup nlsr -f ./NLSR_CONF/$NAME.conf > ./NLSR_OUTPUT/$NAME.OUTPUT 2>&1 &" 
done

