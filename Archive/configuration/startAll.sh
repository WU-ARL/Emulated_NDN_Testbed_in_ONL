#!/bin/bash

CWD=`pwd`

source ~/.topology
source hosts
source routers
source helperFunctions

# ROUTER_HOST_PAIRS contains 'tuples' of
#  router-hosts pair names/prefixes. There can be 
#  duplicate routers but not hosts
echo "Start nfd on routers, transfer client.conf to VMs"

started_nfd=()
for s in "${ROUTER_HOST_PAIRS[@]}" 
do
  pair_info=(${s//:/ })
  ROUTER=${pair_info[0]}
  HOST=${pair_info[1]}
  ADDRESS=${pair_info[3]}
  echo "nfd: $ROUTER, $HOST"
  # array_contains defined in helperFunctions
  if ! array_contains $started_nfd $ROUTER
  then
    # start nfd on ROUTER
    ssh ${!ROUTER} "cd $CWD ; ./start_nfd.sh ./NFD_OUTPUT/$ROUTER.OUTPUT"
    started_nfd+=("$ROUTER")
  fi
    # move client.conf file, add IP routing table, and start nfd on VMs <-- TODO
    sshpass -e ssh -t ${!HOST} "mkdir .ndn "


    # transfer ~/.ndn/client.conf file to VMs
    #  put ../../.ndn/client.conf
    sshpass -e sftp ${!HOST} > sftp.log <<EOF
      put ${HOME}/.ndn/client.conf
      put ./start_nfd.sh
      put nfd.conf
EOF
    # move client.conf file, add IP routing table, and start nfd on VMs <-- TODO
    sshpass -e ssh -t ${!HOST} " mv client.conf .ndn/client.conf ;
       echo $SSHPASS | sudo -S -p '' /sbin/route add -net 192.168.0.0/16 gw $ADDRESS ;
       ./start_nfd.sh ~/nfd.log" 
done


echo "Sleep so nlsr will be able to start"
sleep 10


# start nlsr on all of the routers
echo "start nlsr on routers"
echo ${ROUTER_CONFIG}
for s in "${ROUTER_CONFIG[@]}"
do
  router_info=(${s//:/ })
  HOST=${router_info[3]}
  NAME=${router_info[0]}
  echo "startAll.sh, nlsr: $NAME"
  ssh ${!HOST} "mkdir -p /tmp/log/ndn/nlsr; mkdir -p /tmp/lib/ndn/nlsr"
  #ssh ${!HOST} "cd $CWD ; nohup nlsr -f ./NLSR_CONF/$NAME.conf > ./NLSR_OUTPUT/$NAME.OUTPUT 2>&1 &"
  ssh ${!HOST} "cd $CWD ; nohup ./start_nlsr.sh $NAME > ./NLSR_OUTPUT/$NAME.start_nlsr.out 2>&1 &"

done
