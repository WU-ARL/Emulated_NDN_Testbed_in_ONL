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

#echo $HOSTS
#echo $RTRS
#echo $Michigan_host

#for h in $HOSTS
#do
#  ssh ${!h} "ifconfig data | grep \"inet addr\" "
#done
#
#exit 

echo "# Hosts list:" > ./TestbedInventory
echo "[testbed_hosts]" >> ./TestbedInventory
for h in $HOSTS
do
  echo "ansible_host: ${!h}" > ./host_vars/$h
  echo "ansible_user: ${USER}" >> ./host_vars/$h
  echo "ansible_ssh_pass: ${pw}" >> ./host_vars/$h
  echo "ansible_sudo_pass: ${pw}" >> ./host_vars/$h
  DATA_IP_DATA1=`sshpass -p${pw} ssh ${!h} "ifconfig data | grep \"inet addr\" | cut -d ':' -f 2 | cut -d ' ' -f 1 "`
  baseIp=`echo $DATA_IP_DATA1 | cut -d '.' -f 1-3`
  ndn_rtr_address=$baseIp".1"
  echo "ndn_rtr_address: ${ndn_rtr_address}" >> ./host_vars/$h
  echo "$h" >> ./TestbedInventory
done

echo "" >> ./TestbedInventory
echo "# Router list:" >> ./TestbedInventory
echo "[testbed_rtrs]" >> ./TestbedInventory
echo "#!/bin/bash" > roles/user/files/pingAll.sh
for r in $RTRS
do
  RTR_DATA_IP_DATA1=`sshpass -p${pw} ssh ${!r} "ifconfig data1 | grep \"inet addr\" | cut -d ':' -f 2 | cut -d ' ' -f 1 "`
  RTR_DATA_IP_DATA2=`sshpass -p${pw} ssh ${!r} "ifconfig data2 | grep \"inet addr\" | cut -d ':' -f 2 | cut -d ' ' -f 1 "`
  DATA1_LAST_BYTE=`echo $RTR_DATA_IP_DATA1 | cut -d '.' -f 4`
  DATA2_LAST_BYTE=`echo $RTR_DATA_IP_DATA1 | cut -d '.' -f 4`
  #echo "RTR_DATA_IP_DATA1 = $RTR_DATA_IP_DATA1"
  #echo "RTR_DATA_IP_DATA2 = $RTR_DATA_IP_DATA2"
  if [ "$DATA1_LAST_BYTE" = "2" ]
  then
    RTR_DATA_IP=$RTR_DATA_IP_DATA1
  else
    RTR_DATA_IP=$RTR_DATA_IP_DATA2
  fi
  #echo "RTR_DATA_IP= $RTR_DATA_IP"
  #exit
  cp base_host_vars/${r} ./host_vars/$r
  echo "ndn_ip_addr: ${RTR_DATA_IP}" >> ./host_vars/$r
  echo "ansible_host: ${!r}" >> ./host_vars/$r
  echo "ansible_user: ${USER}" >> ./host_vars/$r
  echo "ansible_ssh_pass: ${pw}" >> ./host_vars/$r
  echo "ansible_sudo_pass: ${pw}" >> ./host_vars/$r
  echo "$r" >> ./TestbedInventory
  PREFIX=`grep default_prefix: base_host_vars/${r} | cut -d ':' -f 2`
  echo "ndnping -c 5 $PREFIX" >> roles/user/files/pingAll.sh
done

echo "[all:vars]" >> ./TestbedInventory
echo "ndnNetwork=/ndn" >> ./TestbedInventory
echo "hyperbolic_state=on" >> ./TestbedInventory
echo "tcp_port=6363" >> ./TestbedInventory
echo "udp_port=6363" >> ./TestbedInventory
echo "multicast_port=56363" >> ./TestbedInventory
echo "" >> ./TestbedInventory

