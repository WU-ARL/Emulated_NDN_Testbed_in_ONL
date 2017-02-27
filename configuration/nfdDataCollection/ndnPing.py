#!/usr/bin/python

# TODO:
# Send multiple ping requests for each neighbor and then take the average
# Update the return message format

import sys
import os
import subprocess
import random
from neighbors import my_neighbors
from process_topology import ip_prefix2site_prefix

interest = sys.argv[1]
site = interest.split("/script")[0]

# print site
n = my_neighbors[site]
# print n

proc_list = []

cmd = "touch /tmp/ndn_result.txt"
os.system(cmd)

cmd = "cat /tmp/ndn_result.txt"
proc = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True)
(out, err) = proc.communicate()

rand_num = random.randint(1,100)
if rand_num > 50:
  os.system("./ndnPingUpdate.py " + interest + " &")

print out

"""
for dest_ip_prefix in n:
  destination = ip_prefix2site_prefix[dest_ip_prefix]
  cmd = "ndnping -c 3 " +  destination

  proc = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True)
  (out, err) = proc.communicate()
  print out
  if 'Avg' in out:
    out = out.split("/")
    result += site + ":" + dest_ip_prefix + "+" + out[-2] + "&"

# print result
cmd = "echo \"" + result + " \" > ndn_result.txt"
os.system(cmd)
"""
