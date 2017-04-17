#!/bin/bash

# change default to actual log directory

FILENAME="nfd.log"
DEFAULT="/usr/local/var/log/ndn"
T_DEFAULT="/tmp"
if [$1 -eq ""]
then
  LOG_PATH=$DEFAULT
else
  LOG_PATH=$1
fi
#FIX THIS
#LOG_PATH=$T_DEFAULT
cd $LOG_PATH
FILESIZE=$(wc -c "$FILENAME" | grep -o "[0-9]\+")
echo "$FILESIZE"
