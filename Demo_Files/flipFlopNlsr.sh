#!/bin/bash

source ~/.topology

while true
do

  cp ua.conf.MOD ../configuration/NLSR_CONF/ua.conf
  cp wu.conf.MOD ../configuration/NLSR_CONF/wu.conf

  echo "Modified"
  ssh $h28x1 "killall nlsr"
  ssh $h3x1  "killall nlsr"
  sleep 120 
  cp ua.conf.ORIG ../configuration/NLSR_CONF/ua.conf
  cp wu.conf.ORIG ../configuration/NLSR_CONF/wu.conf

  echo "Original"
  ssh $h28x1 "killall nlsr"
  ssh $h3x1  "killall nlsr"
  sleep 120 
done


