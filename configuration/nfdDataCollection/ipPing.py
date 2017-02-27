#!/usr/bin/python

import sys
import os
import subprocess
from neighbors import my_neighbors

interest = sys.argv[1]
site = interest.split("/script")[0]
n = my_neighbors[site]
#print site
#print n

result = ""

for destination in n:
  cmd = "ping -W 1 -c 1 -n -q " + destination
  proc = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True)
  (out, err) = proc.communicate()
  if '/' in out:
    out = out.split("/")
    result += site + ":" + destination + "+" + out[-2] + "&"

print result
