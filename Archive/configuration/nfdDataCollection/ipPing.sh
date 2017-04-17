#!/bin/bash

CWD=`pwd`

source ~/.topology
source ../hosts
source ../routers

OIFS=$IFS
count=0

# read linksList into linksArr
IFS=$'\n'
linksArr=($(cat $CWD/linksList))
IFS=$OIFS

# take average RTT from ping on each router in 'hosts' file
for s in "${ROUTER_HOST_PAIRS[@]}"
do
  IFS=$'\ '
  pair_info=(${s//:/ })
  ROUTER=${pair_info[0]}

  # for each line in linksArr, parse site name and neighbor's ip address
  for t in "${linksArr[@]}"
  do
    IFS=$'\ '
    site_info=(${ROUTER_CONFIG[$count]//:/ })
    SITE=${site_info[1]}

 # if a node is a neighbor
    if [[ `echo $t | grep -e $SITE ` ]]; then
      if [[ `echo $1 | grep -e $SITE ` ]]; then
  # extract its IP address and ping for RTT
        IP=${t}
        IP=${IP##* }   
        PING_OUT="$(ping -c 5 -n -q $IP)"

  # extract RTT stats
        RTT=${PING_OUT##*=}
        RTT=${RTT% *}

  # parse RTT stats 
        IFS='/'
        arr=(${RTT})
  
  # extract average RTT
        RTT_AVG=${arr[1]}
        if [ -n "$RTT_AVG" ] 
        then
          echo "$ROUTER/$IP: $RTT_AVG"
        fi
      fi
    fi
  done
  count=$((count+1))

done
IFS=$OIFS
