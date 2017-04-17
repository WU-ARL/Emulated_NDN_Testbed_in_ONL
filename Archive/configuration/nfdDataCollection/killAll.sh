#!/bin/bash

source ~/.topology
source hosts
source helperFunctions

CWD=`pwd`

# --- GET BACK TO THIS ---
# ***********************************
# *** This is not tested/complete ***
# ***********************************
# echo "Kill Traffic"
# ./killTraffic.sh

killed_nfd=()
for s in "${ROUTER_HOST_PAIRS[@]}" 
do
  pair_info=(${s//:/ })
  ROUTER=${pair_info[0]}
  HOST=${pair_info[1]}
  
  echo "$ROUTER, $HOST"

  # array_contains defined in helperFunctions
  if ! array_contains $killed_nfd $ROUTER
  then
    ssh ${!ROUTER} "killall nfd ; killall nlsr"
    killed_nfd+=("$ROUTER")
  fi
  ssh ${!HOST} "killall nfd ; killall nfdstat_c" 
done

