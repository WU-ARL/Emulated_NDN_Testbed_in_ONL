#!/usr/bin/python

# NOTE: Please modify links_file_name to run the scripts on the
# real-world NDN Testbed

# Used by the ipPing.py and ndnPing.py script
# The my_neighbors dictionary is keyed by the name prefixes
# For ech key, the list of neighboring IP addresses are stored

import sys
import os
import process_topology as topo

links_file_name = ""
if topo.RUN_IN_ONL == 1:
  links_file_name = 'linksList'
else:
  links_file_name = 'linksList.testbed'

my_neighbors = dict()
f = open(links_file_name, 'r') # for ONL

for line in f:
  line = line.rstrip()
  key = line.split(" ")
  #print key
  site = key[1]
  ip = key[2]

  if site in my_neighbors:
    my_neighbors[site].append(ip)
  else:
    my_neighbors[site] = []
    my_neighbors[site].append(ip)

#print my_neighbors
