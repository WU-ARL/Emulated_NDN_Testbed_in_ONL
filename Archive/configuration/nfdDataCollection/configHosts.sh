#!/bin/bash
CWD=`pwd`

source ~/.topology
source ../hosts

# ROUTER_HOST_PAIRS contains 'tuples' of
#  router-hosts pair names. There can be 
#  duplicate routers but not hosts
# 
# Host file format is [router name]:[host name]:[prefix advertised]
for s in "${ROUTER_HOST_PAIRS[@]}" 
do
  pair_info=(${s//:/ })
  ROUTER=${pair_info[0]}
  HOST=${pair_info[1]}
  PREFIX=${pair_info[2]}
  
  ssh ${!HOST} "source ~/.topology;
             cd $CWD ;
             nfdc create udp4://$ROUTER:6363
             nfdc add-nexthop -c 1 / udp4://$ROUTER:6363" 
done
