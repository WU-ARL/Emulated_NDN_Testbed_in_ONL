#!/bin/bash
CWD=pwd

source ~/.topology
source hosts

for s in "${ROUTER_HOST_PAIRS[@]}" 
do
  pair_info=(${s//:/ })
  HOST=${pair_info[1]}
  ROUTER_IP=${pair_info[4]}

  sshpass -e ssh -t ${!HOST} "nfdc create udp4://$ROUTER_IP:6363
                              nfdc add-nexthop -c 1 / udp4://$ROUTER_IP:6363" 
done