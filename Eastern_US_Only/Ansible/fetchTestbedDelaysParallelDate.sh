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

#source /Users/jdd/.profile

for r in $RTRS
do
  #        sshpass -p$1 scp tools.sh $vmHostname:~/
  #RTR_DATA_IP_DATA1=`sshpass -p${pw} ssh ${!r} "ifconfig data1 | grep \"inet addr\" | cut -d ':' -f 2 | cut -d ' ' -f 1 "`
  echo "${r}"
  mkdir -p RESULTS/${r}
  sshpass -p${pw} scp ${!r}:/tmp/NOC/ping_delay_tests/TESTBED_DELAYS/${r}/\* RESULTS/${r}/
done

