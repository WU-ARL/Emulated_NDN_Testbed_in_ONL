#!/bin/bash



echo "Checking for basic connectivity. This could take a couple minutes..."
FAILURES=`~onl/bin/pingAllHosts.pl | grep FAIL`

if [ -n "$FAILURES" ]
then
   echo "There were some FAILURES "
   echo "$FAILURES"
   echo "try running $0 again and if it still fails, investigate..."
   exit 0
else
   echo "zero FAILURES "
fi

# prompt user for VM password
read -p "VM Password: " -s SSHPASS ; echo
export SSHPASS

echo "startAll.sh"
./startAll.sh 
echo "configAll.sh"
./configAll.sh 

# *****************************************************************
# *** I do not have running the server(s)/client(s) as part of  ***
# *** the script but it should be pretty easy to get them going ***
# *** doing something similar to below. I deleted the files     ***
# *** refrenced below from my repo to avoid confusion           ***
# *****************************************************************

#echo "runTrafficServers.sh"
#./runTrafficServers.sh 
#echo "runTrafficClients.sh"
#if [ $# -eq 1 ]
#then
#  INTERVAL=$1
#  ./runTrafficClients.sh $INTERVAL 
#else
#  ./runTrafficClients.sh 
#fi
