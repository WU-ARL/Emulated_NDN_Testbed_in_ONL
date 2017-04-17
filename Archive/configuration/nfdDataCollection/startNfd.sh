#!/bin/bash

CWD=`pwd`

source ~/.topology
source ../hosts
source helperFunctions

echo "start nfd on all machines"

started_nfd=()
for s in "${ROUTER_HOST_PAIRS[@]}"
do
  pair_info=(${s//:/ })
  ROUTER=${pair_info[0]}

  HOST=${pair_info[1]}
  echo "start_nfd.sh, nfd: $ROUTER, $HOST"
  # array_contains defined in helperFunctions
  if ! array_contains $started_nfd $ROUTER
  then
    # start nfd on ROUTER
    ssh ${!ROUTER} "cd $CWD ; ./start_nfd.sh"
    started_nfd+=("$ROUTER")
  fi
  # start nfd on HOST
  ssh ${!HOST} "cd $CWD ; ./start_nfd.sh"
done

