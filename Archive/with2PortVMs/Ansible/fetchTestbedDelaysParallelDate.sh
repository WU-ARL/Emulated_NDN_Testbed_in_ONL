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

exit

echo "WU:"
mkdir -p RESULTS/WU/
FILESTR=/home/ndnops/ndn-ops/NOC/ping_delay_tests/TESTBED_DELAYS/WU/parallel_ndnping\*
scpwashu "$FILESTR" RESULTS/WU/

exit

echo "UFPA:"
mkdir -p RESULTS/UFPA/${DATE}
FILESTR=/home/ndnops/ndn-ops/NOC/ping_delay_tests/TESTBED_DELAYS/UFPA/parallel_ndnping\*${DATE}_00\*
scpufpa "$FILESTR" RESULTS/UFPA/${DATE}
#scpufpa '/home/ndnops/ndn-ops/NOC/ping_delay_tests/TESTBED_DELAYS/UFPA/parallel_ndnping*${DATE}*'  RESULTS/UFPA

echo "BASEL:"
mkdir -p RESULTS/BASEL/${DATE}
FILESTR=/home/ndnops/ndn-ops/NOC/ping_delay_tests/TESTBED_DELAYS/BASEL/parallel_ndnping\*${DATE}_00\*
scpbasel "$FILESTR" RESULTS/BASEL/${DATE}
#scpbasel '/home/ndnops/ndn-ops/NOC/ping_delay_tests/TESTBED_DELAYS/BASEL/parallel_ndnping*${DATE}*'  RESULTS/BASEL

#echo "BUPT:"
#mkdir -p RESULTS/BUPT/${DATE}
FILESTR=/home/ndnops/ndn-ops/NOC/ping_delay_tests/TESTBED_DELAYS/BUPT/parallel_ndnping\*${DATE}_00\*
#scpbupt "$FILESTR" RESULTS/BUPT/${DATE}
##scpbupt '/home/ndnops/ndn-ops/NOC/ping_delay_tests/TESTBED_DELAYS/BUPT/parallel_ndnping*${DATE}*'  RESULTS/BUPT

echo "TONGJI:"
mkdir -p RESULTS/TONGJI/${DATE}
FILESTR=/home/ndnops/ndn-ops/NOC/ping_delay_tests/TESTBED_DELAYS/TONGJI/parallel_ndnping\*${DATE}_00\*
scptongji "$FILESTR" RESULTS/TONGJI/${DATE}
#scptongji '/home/ndnops/ndn-ops/NOC/ping_delay_tests/TESTBED_DELAYS/TONGJI/parallel_ndnping*${DATE}*'  RESULTS/TONGJI

echo "GOETTINGEN:"
mkdir -p RESULTS/GOETTINGEN/${DATE}
FILESTR=/home/ndnops/ndn-ops/NOC/ping_delay_tests/TESTBED_DELAYS/GOETTINGEN/parallel_ndnping\*${DATE}_00\*
scpgoettingen "$FILESTR" RESULTS/GOETTINGEN/${DATE}
#scpgoettingen '/home/ndnops/ndn-ops/NOC/ping_delay_tests/TESTBED_DELAYS/GOETTINGEN/parallel_ndnping*${DATE}*'  RESULTS/GOETTINGEN

echo "ARIZONA:"
mkdir -p RESULTS/ARIZONA/${DATE}
FILESTR=/home/ndnops/ndn-ops/NOC/ping_delay_tests/TESTBED_DELAYS/ARIZONA/parallel_ndnping\*${DATE}_00\*
scparizona "$FILESTR" RESULTS/ARIZONA/${DATE}
#scparizona '/home/ndnops/ndn-ops/NOC/ping_delay_tests/TESTBED_DELAYS/ARIZONA/parallel_ndnping*${DATE}*'  RESULTS/ARIZONA

echo "BYU:"
mkdir -p RESULTS/BYU/${DATE}
FILESTR=/home/ndnops/ndn-ops/NOC/ping_delay_tests/TESTBED_DELAYS/BYU/parallel_ndnping\*${DATE}_00\*
scpbyu "$FILESTR" RESULTS/BYU/${DATE}
#scpbyu '/home/ndnops/ndn-ops/NOC/ping_delay_tests/TESTBED_DELAYS/BYU/parallel_ndnping*${DATE}*'  RESULTS/BYU

echo "CSU:"
mkdir -p RESULTS/CSU/${DATE}
FILESTR=/home/ndnops/ndn-ops/NOC/ping_delay_tests/TESTBED_DELAYS/CSU/parallel_ndnping\*${DATE}_00\*
scpcsu "$FILESTR" RESULTS/CSU/${DATE}
#scpcsu '/home/ndnops/ndn-ops/NOC/ping_delay_tests/TESTBED_DELAYS/CSU/parallel_ndnping*${DATE}*'  RESULTS/CSU

echo "UIUC:"
mkdir -p RESULTS/UIUC/${DATE}
FILESTR=/home/ndnops/ndn-ops/NOC/ping_delay_tests/TESTBED_DELAYS/UIUC/parallel_ndnping\*${DATE}_00\*
scpuiuc "$FILESTR" RESULTS/UIUC/${DATE}
#scpuiuc '/home/ndnops/ndn-ops/NOC/ping_delay_tests/TESTBED_DELAYS/UIUC/parallel_ndnping*${DATE}*'  RESULTS/UIUC

echo "MEMPHIS:"
mkdir -p RESULTS/MEMPHIS/${DATE}
FILESTR=/home/ndnops/ndn-ops/NOC/ping_delay_tests/TESTBED_DELAYS/MEMPHIS/parallel_ndnping\*${DATE}_00\*
scpmemphis "$FILESTR" RESULTS/MEMPHIS/${DATE}
#scpmemphis '/home/ndnops/ndn-ops/NOC/ping_delay_tests/TESTBED_DELAYS/MEMPHIS/parallel_ndnping*${DATE}*'  RESULTS/MEMPHIS

echo "NEU:"
mkdir -p RESULTS/NEU/${DATE}
FILESTR=/home/ndnops/ndn-ops/NOC/ping_delay_tests/TESTBED_DELAYS/NEU/parallel_ndnping\*${DATE}_00\*
scpneu "$FILESTR" RESULTS/NEU/${DATE}
#scpneu '/home/ndnops/ndn-ops/NOC/ping_delay_tests/TESTBED_DELAYS/NEU/parallel_ndnping*${DATE}*'  RESULTS/NEU

echo "UCI:"
mkdir -p RESULTS/UCI/${DATE}
FILESTR=/home/ndnops/ndn-ops/NOC/ping_delay_tests/TESTBED_DELAYS/UCI/parallel_ndnping\*${DATE}_00\*
scpuci "$FILESTR" RESULTS/UCI/${DATE}
#scpuci '/home/ndnops/ndn-ops/NOC/ping_delay_tests/TESTBED_DELAYS/UCI/parallel_ndnping*${DATE}*'  RESULTS/UCI

echo "UCLA:"
mkdir -p RESULTS/UCLA/${DATE}
FILESTR=/home/ndnops/ndn-ops/NOC/ping_delay_tests/TESTBED_DELAYS/UCLA/parallel_ndnping\*${DATE}_00\*
scpucla "$FILESTR" RESULTS/UCLA/${DATE}
#scpucla '/home/ndnops/ndn-ops/NOC/ping_delay_tests/TESTBED_DELAYS/UCLA/parallel_ndnping*${DATE}*'  RESULTS/UCLA

echo "REMAP:"
mkdir -p RESULTS/REMAP/${DATE}
FILESTR=/home/ndnops/ndn-ops/NOC/ping_delay_tests/TESTBED_DELAYS/REMAP/parallel_ndnping\*${DATE}_00\*
scpremap "$FILESTR" RESULTS/REMAP/${DATE}
#scpremap '/home/ndnops/ndn-ops/NOC/ping_delay_tests/TESTBED_DELAYS/REMAP/parallel_ndnping*${DATE}*'  RESULTS/REMAP

echo "MICHIGAN:"
mkdir -p RESULTS/MICHIGAN/${DATE}
FILESTR=/home/ndnops/ndn-ops/NOC/ping_delay_tests/TESTBED_DELAYS/MICHIGAN/parallel_ndnping\*${DATE}_00\*
scpmichigan "$FILESTR" RESULTS/MICHIGAN/${DATE}
#scpmichigan '/home/ndnops/ndn-ops/NOC/ping_delay_tests/TESTBED_DELAYS/MICHIGAN/parallel_ndnping*${DATE}*'  RESULTS/MICHIGAN

echo "URJC:"
mkdir -p RESULTS/URJC/${DATE}
FILESTR=/home/ndnops/ndn-ops/NOC/ping_delay_tests/TESTBED_DELAYS/URJC/parallel_ndnping\*${DATE}_00\*
scpurjc "$FILESTR" RESULTS/URJC/${DATE}
#scpurjc '/home/ndnops/ndn-ops/NOC/ping_delay_tests/TESTBED_DELAYS/URJC/parallel_ndnping*${DATE}*'  RESULTS/URJC

echo "SystemX:"
mkdir -p RESULTS/SystemX/${DATE}
FILESTR=/home/ndnops/ndn-ops/NOC/ping_delay_tests/TESTBED_DELAYS/SystemX/parallel_ndnping\*${DATE}_00\*
scpsystemx "$FILESTR" RESULTS/SystemX/${DATE}
#scpsystemx '/home/ndnops/ndn-ops/NOC/ping_delay_tests/TESTBED_DELAYS/SystemX/parallel_ndnping*${DATE}*'  RESULTS/SystemX

echo "LIP6:"
mkdir -p RESULTS/LIP6/${DATE}
FILESTR=/home/ndnops/ndn-ops/NOC/ping_delay_tests/TESTBED_DELAYS/LIP6/parallel_ndnping\*${DATE}_00\*
scplip6 "$FILESTR" RESULTS/LIP6/${DATE}
#scplip6 '/home/ndnops/ndn-ops/NOC/ping_delay_tests/TESTBED_DELAYS/LIP6/parallel_ndnping*${DATE}*'  RESULTS/LIP6

#echo "NIST:"
#mkdir -p RESULTS/NIST/${DATE}
FILESTR=/home/ndnops/ndn-ops/NOC/ping_delay_tests/TESTBED_DELAYS/NIST/parallel_ndnping\*${DATE}_00\*
#scpnist "$FILESTR" RESULTS/NIST/${DATE}
##scpnist '/home/ndnops/ndn-ops/NOC/ping_delay_tests/TESTBED_DELAYS/NIST/parallel_ndnping*${DATE}*'  RESULTS/NIST

echo "INDONESIA:"
mkdir -p RESULTS/INDONESIA/${DATE}
FILESTR=/home/ndnops/ndn-ops/NOC/ping_delay_tests/TESTBED_DELAYS/INDONESIA/parallel_ndnping\*${DATE}_00\*
scpindonesia "$FILESTR" RESULTS/INDONESIA/${DATE}
#scpindonesia '/home/ndnops/ndn-ops/NOC/ping_delay_tests/TESTBED_DELAYS/INDONESIA/parallel_ndnping*${DATE}*'  RESULTS/INDONESIA

echo "PADUA:"
mkdir -p RESULTS/PADUA/${DATE}
FILESTR=/home/ndnops/ndn-ops/NOC/ping_delay_tests/TESTBED_DELAYS/PADUA/parallel_ndnping\*${DATE}_00\*
scppadua "$FILESTR" RESULTS/PADUA/${DATE}
#scppadua '/home/ndnops/ndn-ops/NOC/ping_delay_tests/TESTBED_DELAYS/PADUA/parallel_ndnping*${DATE}*'  RESULTS/PADUA

echo "OSAKA:"
mkdir -p RESULTS/OSAKA/${DATE}
FILESTR=/home/ndnops/ndn-ops/NOC/ping_delay_tests/TESTBED_DELAYS/OSAKA/parallel_ndnping\*${DATE}_00\*
scposaka "$FILESTR" RESULTS/OSAKA/${DATE}
#scposaka '/home/ndnops/ndn-ops/NOC/ping_delay_tests/TESTBED_DELAYS/OSAKA/parallel_ndnping*${DATE}*'  RESULTS/OSAKA

echo "WASEDA:"
mkdir -p RESULTS/WASEDA/${DATE}
FILESTR=/home/ndnops/ndn-ops/NOC/ping_delay_tests/TESTBED_DELAYS/WASEDA/parallel_ndnping\*${DATE}_00\*
scpwaseda "$FILESTR" RESULTS/WASEDA/${DATE}
#scpwaseda '/home/ndnops/ndn-ops/NOC/ping_delay_tests/TESTBED_DELAYS/WASEDA/parallel_ndnping*${DATE}*'  RESULTS/WASEDA

echo "ANYANG:"
mkdir -p RESULTS/ANYANG/${DATE}
FILESTR=/home/ndnops/ndn-ops/NOC/ping_delay_tests/TESTBED_DELAYS/ANYANG/parallel_ndnping\*${DATE}_00\*
scpanyang "$FILESTR" RESULTS/ANYANG/${DATE}
#scpanyang '/home/ndnops/ndn-ops/NOC/ping_delay_tests/TESTBED_DELAYS/ANYANG/parallel_ndnping*${DATE}*'  RESULTS/ANYANG

echo "KISTI:"
mkdir -p RESULTS/KISTI/${DATE}
FILESTR=/home/ndnops/ndn-ops/NOC/ping_delay_tests/TESTBED_DELAYS/KISTI/parallel_ndnping\*${DATE}_00\*
scpkisti "$FILESTR" RESULTS/KISTI/${DATE}
#scpkisti '/home/ndnops/ndn-ops/NOC/ping_delay_tests/TESTBED_DELAYS/KISTI/parallel_ndnping*${DATE}*'  RESULTS/KISTI

echo "TNO:"
mkdir -p RESULTS/TNO/${DATE}
FILESTR=/home/ndnops/ndn-ops/NOC/ping_delay_tests/TESTBED_DELAYS/TNO/parallel_ndnping\*${DATE}_00\*
scptno "$FILESTR" RESULTS/TNO/${DATE}
#scptno '/home/ndnops/ndn-ops/NOC/ping_delay_tests/TESTBED_DELAYS/TNO/parallel_ndnping*${DATE}*'  RESULTS/TNO

echo "NTNU:"
mkdir -p RESULTS/NTNU/${DATE}
FILESTR=/home/ndnops/ndn-ops/NOC/ping_delay_tests/TESTBED_DELAYS/NTNU/parallel_ndnping\*${DATE}_00\*
scpntnu "$FILESTR" RESULTS/NTNU/${DATE}
#scpntnu '/home/ndnops/ndn-ops/NOC/ping_delay_tests/TESTBED_DELAYS/NTNU/parallel_ndnping*${DATE}*'  RESULTS/NTNU

echo "CAIDA:"
mkdir -p RESULTS/CAIDA/${DATE}
FILESTR=/home/ndnops/ndn-ops/NOC/ping_delay_tests/TESTBED_DELAYS/CAIDA/parallel_ndnping\*${DATE}_00\*
scpcaida "$FILESTR" RESULTS/CAIDA/${DATE}
#scpcaida '/home/ndnops/ndn-ops/NOC/ping_delay_tests/TESTBED_DELAYS/CAIDA/parallel_ndnping*${DATE}*'  RESULTS/CAIDA

echo "COPELABS:"
mkdir -p RESULTS/COPELABS/${DATE}
FILESTR=/home/ndnops/ndn-ops/NOC/ping_delay_tests/TESTBED_DELAYS/COPELABS/parallel_ndnping\*${DATE}_00\*
scpcopelabs "$FILESTR" RESULTS/COPELABS/${DATE}
#scpcopelabs '/home/ndnops/ndn-ops/NOC/ping_delay_tests/TESTBED_DELAYS/COPELABS/parallel_ndnping*${DATE}*'  RESULTS/COPELABS

echo "MINHO:"
mkdir -p RESULTS/MINHO/${DATE}
FILESTR=/home/ndnops/ndn-ops/NOC/ping_delay_tests/TESTBED_DELAYS/MINHO/parallel_ndnping\*${DATE}_00\*
scpminho "$FILESTR" RESULTS/MINHO/${DATE}
#scpminho '/home/ndnops/ndn-ops/NOC/ping_delay_tests/TESTBED_DELAYS/MINHO/parallel_ndnping*${DATE}*'  RESULTS/MINHO

echo "SRRU:"
mkdir -p RESULTS/SRRU/${DATE}
FILESTR=/home/ndnops/ndn-ops/NOC/ping_delay_tests/TESTBED_DELAYS/SRRU/parallel_ndnping\*${DATE}_00\*
scpsrru "$FILESTR" RESULTS/SRRU/${DATE}
#scpsrru '/home/ndnops2/ndn-ops/NOC/ping_delay_tests/TESTBED_DELAYS/SRRU/parallel_ndnping*${DATE}*'  RESULTS/SRRU

