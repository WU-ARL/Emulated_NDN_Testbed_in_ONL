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

# Asia
sshpass -p${pw} ssh ${ANYANG_host} "cd ndnrtc; ./ndnrtc-client -c consumer-of-wu.cfg -p rule.conf -t 30 -s  /ndn/kr/anyang/jdd &" &
sshpass -p${pw} ssh ${BUPT_host} "cd ndnrtc; ./ndnrtc-client -c consumer-of-wu.cfg -p rule.conf -t 30 -s  /ndn/cn/edu/bupt/jdd &" &
sshpass -p${pw} ssh ${INDONESIA_host} "cd ndnrtc; ./ndnrtc-client -c consumer-of-wu.cfg -p rule.conf -t 30 -s  /ndn/id/ac/ui/jdd &" &
sshpass -p${pw} ssh ${KISTI_host} "cd ndnrtc; ./ndnrtc-client -c consumer-of-wu.cfg -p rule.conf -t 30 -s  /ndn/kr/re/kisti/jdd &" &
sshpass -p${pw} ssh ${OSAKA_host} "cd ndnrtc; ./ndnrtc-client -c consumer-of-wu.cfg -p rule.conf -t 30 -s  /ndn/jp/ac/osaka-u/jdd &" &
sshpass -p${pw} ssh ${PKUSZ_host} "cd ndnrtc; ./ndnrtc-client -c consumer-of-wu.cfg -p rule.conf -t 30 -s  /ndn/cn/edu/pkusz/jdd &" &
sshpass -p${pw} ssh ${SRRU_host} "cd ndnrtc; ./ndnrtc-client -c consumer-of-wu.cfg -p rule.conf -t 30 -s  /ndn/th/ac/srru/jdd &" &
sshpass -p${pw} ssh ${WASEDA_host} "cd ndnrtc; ./ndnrtc-client -c consumer-of-wu.cfg -p rule.conf -t 30 -s  /ndn/jp/waseda/jdd &" &
sshpass -p${pw} ssh ${TONGJI_host} "cd ndnrtc; ./ndnrtc-client -c consumer-of-wu.cfg -p rule.conf -t 30 -s  /ndn/cn/edu/tongji/jdd &" &
sshpass -p${pw} ssh ${MSU_host} "cd ndnrtc; ./ndnrtc-client -c consumer-of-wu.cfg -p rule.conf -t 30 -s  /ndn/th/ac/msu/jdd &" &

# US
#sshpass -p${pw} ssh ${ARIZONA_host} "cd ndnrtc; ./ndnrtc-client -c consumer-of-wu.cfg -p rule.conf -t 30 -s  /ndn/edu/arizona/jdd &" &
#sshpass -p${pw} ssh ${BYU_host} "cd ndnrtc; ./ndnrtc-client -c consumer-of-wu.cfg -p rule.conf -t 30 -s  /ndn/edu/byu/jdd &" &
#sshpass -p${pw} ssh ${CAIDA_host} "cd ndnrtc; ./ndnrtc-client -c consumer-of-wu.cfg -p rule.conf -t 30 -s  /ndn/org/caida/jdd &" &
#sshpass -p${pw} ssh ${CSU_host} "cd ndnrtc; ./ndnrtc-client -c consumer-of-wu.cfg -p rule.conf -t 30 -s  /ndn/edu/colostate/jdd &" &
#sshpass -p${pw} ssh ${MEMPHIS_host} "cd ndnrtc; ./ndnrtc-client -c consumer-of-wu.cfg -p rule.conf -t 30 -s  /ndn/edu/memphis/jdd &" &
#sshpass -p${pw} ssh ${MICHIGAN_host} "cd ndnrtc; ./ndnrtc-client -c consumer-of-wu.cfg -p rule.conf -t 30 -s  /ndn/edu/umich/jdd &" &
#sshpass -p${pw} ssh ${NEU_host} "cd ndnrtc; ./ndnrtc-client -c consumer-of-wu.cfg -p rule.conf -t 30 -s  /ndn/edu/neu/jdd &" &
#sshpass -p${pw} ssh ${NIST_host} "cd ndnrtc; ./ndnrtc-client -c consumer-of-wu.cfg -p rule.conf -t 30 -s  /ndn/gov/nist/jdd &" &
#sshpass -p${pw} ssh ${UCI_host} "cd ndnrtc; ./ndnrtc-client -c consumer-of-wu.cfg -p rule.conf -t 30 -s  /ndn/edu/uci/jdd &" &
#sshpass -p${pw} ssh ${UCLA_host} "cd ndnrtc; ./ndnrtc-client -c consumer-of-wu.cfg -p rule.conf -t 30 -s  /ndn/edu/ucla/jdd &" &
#sshpass -p${pw} ssh ${REMAP_host} "cd ndnrtc; ./ndnrtc-client -c consumer-of-wu.cfg -p rule.conf -t 30 -s  /ndn/edu/ucla/remap/jdd &" &
#sshpass -p${pw} ssh ${UIUC_host} "cd ndnrtc; ./ndnrtc-client -c consumer-of-wu.cfg -p rule.conf -t 30 -s  /ndn/edu/illinois/jdd &" &
#sshpass -p${pw} ssh ${WU_host} "cd ndnrtc; ./ndnrtc-client -c consumer-of-wu.cfg -p rule.conf -t 30 -s  /ndn/edu/wustl/jdd &" &

# SA
#sshpass -p${pw} ssh ${UFPA_host} "cd ndnrtc; ./ndnrtc-client -c consumer-of-wu.cfg -p rule.conf -t 30 -s  /ndn/br/ufpa/jdd &" &

# Europe
#sshpass -p${pw} ssh ${BASEL_host} "cd ndnrtc; ./ndnrtc-client -c consumer-of-wu.cfg -p rule.conf -t 30 -s  /ndn/ch/unibas/jdd &" &
#sshpass -p${pw} ssh ${COPELABS_host} "cd ndnrtc; ./ndnrtc-client -c consumer-of-wu.cfg -p rule.conf -t 30 -s  /ndn/pt/ulusofona/copelabs/jdd &" &
#sshpass -p${pw} ssh ${GOETTINGEN_host} "cd ndnrtc; ./ndnrtc-client -c consumer-of-wu.cfg -p rule.conf -t 30 -s  /ndn/de/uni-goettingen/jdd &" &
#sshpass -p${pw} ssh ${LIP6_host} "cd ndnrtc; ./ndnrtc-client -c consumer-of-wu.cfg -p rule.conf -t 30 -s  /ndn/fr/lip6/jdd &" &
#sshpass -p${pw} ssh ${MINHO_host} "cd ndnrtc; ./ndnrtc-client -c consumer-of-wu.cfg -p rule.conf -t 30 -s  /ndn/pt/uminho/jdd &" &
#sshpass -p${pw} ssh ${NTNU_host} "cd ndnrtc; ./ndnrtc-client -c consumer-of-wu.cfg -p rule.conf -t 30 -s  /ndn/no/ntnu/jdd &" &
#sshpass -p${pw} ssh ${PADUA_host} "cd ndnrtc; ./ndnrtc-client -c consumer-of-wu.cfg -p rule.conf -t 30 -s  /ndn/it/unipd/jdd &" &
#sshpass -p${pw} ssh ${SYSTEMX_host} "cd ndnrtc; ./ndnrtc-client -c consumer-of-wu.cfg -p rule.conf -t 30 -s  /ndn/fr/irt-systemx/jdd &" &
#sshpass -p${pw} ssh ${TNO_host} "cd ndnrtc; ./ndnrtc-client -c consumer-of-wu.cfg -p rule.conf -t 30 -s  /ndn/nl/tno/jdd &" &
#sshpass -p${pw} ssh ${URJC_host} "cd ndnrtc; ./ndnrtc-client -c consumer-of-wu.cfg -p rule.conf -t 30 -s  /ndn/es/urjc/jdd &" &

