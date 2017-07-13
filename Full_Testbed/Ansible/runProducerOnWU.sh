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


sshpass -p${pw} ssh ${WU}      "nfdc register /ndn/edu/wustl/jdd udp4://192.168.4.2"
sshpass -p${pw} ssh ${WU_host} "cd ndnrtc; tar -xzf test-source-320x240.argb.tar.gz"
sshpass -p${pw} ssh ${WU_host} "cd ndnrtc; ./ndnrtc-client -c wu-producer.cfg -i clientA -p rule.conf -t 300 -s /ndn/edu/wustl/jdd"
