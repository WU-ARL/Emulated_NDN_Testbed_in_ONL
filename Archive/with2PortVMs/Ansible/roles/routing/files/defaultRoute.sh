#!/bin/bash

hAddress_data1=`ifconfig data1 | grep "inet addr" | cut -d ':' -f 2 | cut -d ' ' -f 1`
hAddress_data2=`ifconfig data2 | grep "inet addr" | cut -d ':' -f 2 | cut -d ' ' -f 1`
data1_last_byte=`echo $hAddress_data1 | cut -d '.' -f 4`
data2_last_byte=`echo $hAddress_data2 | cut -d '.' -f 4`
if [ "$data1_last_byte" = "2" ]
then
  baseIp=`echo $hAddress_data1 | cut -d '.' -f 1-3`
  rAddress=$baseIp".1"
  baseIp16=`echo $hAddress_data1 | cut -d '.' -f 1-2`
else
  baseIp=`echo $hAddress_data2 | cut -d '.' -f 1-3`
  rAddress=$baseIp".1"
  baseIp16=`echo $hAddress_data2 | cut -d '.' -f 1-2`
fi

mask=$baseIp16".0.0"
dRoute=`route | grep  $mask`
if [ -z "$dRoute" ]
then
  sudo route add -net ${mask}/16 gw $rAddress 
fi
