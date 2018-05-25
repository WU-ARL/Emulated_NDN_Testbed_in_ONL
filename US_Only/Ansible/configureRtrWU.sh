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


sshpass  -p${pw} ssh ${WU} " nfdc register /ndn/edu/wustl/jdd udp4://192.168.4.2"
