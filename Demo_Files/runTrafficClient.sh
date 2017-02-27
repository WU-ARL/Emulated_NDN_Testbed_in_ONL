#!/bin/bash

if [ $# -ne 1 ]
then
  echo "Usage: $0 <VM password>"
  exit 0
fi

source ~/.topology

sshpass -p$1 ssh $VMsmall29 "ndn-traffic -i 20 NDN_Traffic_Client_KISTI >& ndn-traffic.log"


