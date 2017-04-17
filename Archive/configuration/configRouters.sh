#!/bin/bash
CWD=`pwd`

source ~/.topology
source hosts

# ROUTER_HOST_PAIRS contains 'tuples' of
#  router-hosts pair names/prefixes. There can be 
#  duplicate routers but not hosts 
# 
# Host file format is [router name]:[host name]:[prefix advertised]
for s in "${ROUTER_HOST_PAIRS[@]}" 
do
  # split string so we can get : separated parts
  pair_info=(${s//:/ })
  ROUTER=${pair_info[0]}
  #HOST=${pair_info[1]}
  PREFIX=${pair_info[2]}
  HOSTIP=${pair_info[5]}
  
  ssh ${!ROUTER} "source ~/.topology ;
                  nfdc create udp4://$HOSTIP:6363 ;
                  nfdc add-nexthop -c 1 /$PREFIX/ udp4://$HOSTIP:6363" 
done
