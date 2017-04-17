#!/usr/bin/python

# TODO:
# Send multiple ping requests for each neighbor and then take the average
# Update the return message format

import sys
import os
import subprocess
from neighbors import my_neighbors
from process_topology import ip_prefix2site_prefix

interest = sys.argv[1]
site = interest.split("/script")[0]

n = my_neighbors[site]
result = ""
proc_list = []

for dest_ip_prefix in n:
  destination = ip_prefix2site_prefix[dest_ip_prefix]
  cmd = "ndnping -c 3 " +  destination

  proc = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True)
  (out, err) = proc.communicate()
  if 'Avg' in out:
    out = out.split("/")
    result += site + ":" + dest_ip_prefix + "+" + out[-2] + "&"

# print result
cmd = "echo \"" + result + " \" > /tmp/ndn_result.txt"
os.system(cmd)
