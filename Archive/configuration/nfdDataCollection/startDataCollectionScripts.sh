#!/bin/bash

CWD=`pwd`

source ~/.topology
source ../hosts
source ../routers

# start nfdstat_c on all hosts
echo "start nfdstat_c on all hosts"
INTEREST_FILTER=$1
if [ $INTEREST_FILTER -eq ""]
then
  echo "USAGE: ./nfdstat_c [interest_filter]"
fi
started_nfdstat=()
count=0
for s in "${ROUTER_HOST_PAIRS[@]}"
do
  pair_info=(${s//:/ })
  site_info=(${ROUTER_CONFIG[$count]//:/ })
  HOST=${pair_info[1]}
  SITE=${site_info[1]}
  ROUTER=${pair_info[0]}
  echo "nfdstat_c -p $INTEREST_FILTER/$SITE/script for $ROUTER"
  ssh ${!ROUTER} "cd $CWD ; ./build/nfdstat_c -p $INTEREST_FILTER/$SITE/script -d 1 >> /dev/null 2>&1 &"
  count=$((count+1))
done

