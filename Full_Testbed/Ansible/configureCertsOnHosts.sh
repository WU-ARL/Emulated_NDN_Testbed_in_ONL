#!/bin/bash

if [ $# -ne 1 ]
then
  echo "Usage: $0 <VM Password>"
  exit 
else
  pw=$1
fi

source ~/.topology
source ./vmHosts

for h in $HOSTS
do
  echo "$h"
  sshpass -p${pw} ssh ${!h} "cd ndnrtc; ./certHost.sh"
done
