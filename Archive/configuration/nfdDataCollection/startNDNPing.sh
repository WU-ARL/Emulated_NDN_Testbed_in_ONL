#!/bin/bash

CWD=`pwd`

source ~/.topology
source ../hosts
source ../routers

# start ndnpingserver on all hosts
echo "start ndnpingserver on all hosts"
INTEREST_FILTER=$1
count=0
for s in "${ROUTER_HOST_PAIRS[@]}"
do
  pair_info=(${s//:/ })
  site_info=(${ROUTER_CONFIG[$count]//:/ })
  HOST=${pair_info[1]}
  SITE=${site_info[1]}
  ROUTER=${pair_info[0]}
  echo "ndnpingserver /ndn/$SITE for $ROUTER"
  ssh ${!ROUTER} "cd $CWD ; ndnpingserver /ndn/$SITE >> /dev/null 2>&1 &"
  count=$((count+1))
done

