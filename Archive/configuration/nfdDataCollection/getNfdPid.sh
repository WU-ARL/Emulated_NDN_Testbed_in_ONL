#!/bin/bash
pid=$(pgrep ^nfd$)
if [ -z "$pid" ]
then
  printf "nfd not started\n"
else
  echo $pid
fi
