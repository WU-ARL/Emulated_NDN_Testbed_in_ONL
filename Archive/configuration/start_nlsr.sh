#!/bin/bash

NAME=$1
# remove any old restart log so we cn see how much it restarts each time.
rm ./NLSR_OUTPUT/$NAME.NLSR.restart.log
while true
do
  echo "starting nlsr >$NAME<"
  nlsr -f ./NLSR_CONF/$NAME.conf > ./NLSR_OUTPUT/$NAME.OUTPUT 2>&1 
  DATE=`date`
  echo "${DATE}: nlsr died, sleep 10 and restart" >> ./NLSR_OUTPUT/$NAME.NLSR.restart.log 
  sleep 10
done
