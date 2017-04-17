#!/bin/bash

DEFAULT="/ndn"

if [$1 -eq ""]
then
  PREFIX=$DEFAULT
else
  PREFIX=$1
fi


# run data collection clients and server
./startDataCollectionScripts.sh $PREFIX
./startDataCollection.sh $PREFIX
