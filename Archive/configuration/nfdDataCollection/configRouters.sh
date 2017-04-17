#!/bin/bash
CWD=`pwd`

source ~/.topology
source ../hosts
source ../routers

# ROUTER_HOST_PAIRS contains 'tuples' of
#  router-hosts pair names/prefixes. There can be 
#  duplicate routers but not hosts 
# 
# Host file format is [router name]:[host name]:[prefix advertised]
count=0
for s in "${ROUTER_HOST_PAIRS[@]}" 
do
  # split string so we can get : separated parts
  pair_info=(${s//:/ })
  ROUTER=${pair_info[0]}
  HOST=${pair_info[1]}
  PREFIX=${pair_info[2]}

  site_info=(${ROUTER_CONFIG[$count]//:/ })
  SITE=${site_info[1]}
  
echo "Registering $1/$SITE to $HOST on router $ROUTER"

  ssh ${!ROUTER} "source ~/.topology;
               cd $CWD ;
               nfdc register $1/$SITE udp4://$HOST:6363"
  count=$((count+1))

#               nfdc create udp4://$HOST:6363 ;
#               nfdc add-nexthop -c 1 /$PREFIX/ udp4://$HOST:6363" 
done
