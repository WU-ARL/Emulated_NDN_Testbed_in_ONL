#!/bin/bash

# ndnsec get-default
# ndnsec get-default -c
# ndnsec get-default -k

if [ $# -ne 1 ]
then
  echo "Usage: $0 <ndn name>"
  echo "Example: $0 /ndn/edu/wustl"
  exit 1
else
  NDN_NAME=$1
fi

DEF_NAME=`sudo su - ndnsec -c "ndnsec get-default 2> /dev/null"`
if [ $? -ne 0 ]
then
  echo "failed to get default name"
  exit 1
fi

if [ "$NDN_NAME" != "$DEF_NAME" ]
then
  echo "given name ($NDN_NAME) was not default name ($DEF_NAME)"
  exit 1
fi

exit 0
