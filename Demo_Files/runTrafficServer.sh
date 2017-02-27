#!/bin/bash

if [ $# -ne 1 ]
then
  echo "Usage: $0 <VM password>"
  exit 0
fi

source ~/.topology

sshpass -p$1 ssh $VMsmall37 "ndn-traffic-server NDN_Traffic_Server_KISTI >& ndn-traffic-server.log"
