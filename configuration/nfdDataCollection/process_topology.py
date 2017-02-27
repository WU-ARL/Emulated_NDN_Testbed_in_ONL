#!/usr/bin/python

# Used by the ipPing.py and ndnPing.py scripts
# The my_neighbors dictionary is keyed by the name prefixes
# For ech key, the list of neighboring IP addresses are stored

import sys
import os

# 1: ONL; 0: NDN TESTBED
RUN_IN_ONL = 1

#my_neighbors = dict()
site_neighbors = dict()

site2site_prefix = dict()
site_prefix2site = dict()

site2ip_prefix = dict()
site_prefix2ip_prefix = dict()

ip_prefix2site = dict()
ip_prefix2site_prefix = dict()

if RUN_IN_ONL == 1:
  f = open('../routers', 'r')
else:
  f = open('../routers.testbed', 'r')

# urjc:es/urjc:insula:h44x1:192.168.44.1:lip6:orange:basel:padua:wu
for line in f:
  if "\"" in line:
    line = line.rstrip()
    line = line.split('"')[1]
    line = line.split('"')[0]
    comps = line.split(':')

    site = comps[0]
    site_prefix = "/ndn/" + comps[1]
    site2site_prefix[site] = site_prefix
    site_prefix2site[site_prefix] = site

    host = comps[2]
    onl_host = comps[3]
    ip_prefix = comps[4]

    site2ip_prefix[site] = ip_prefix
    site_prefix2ip_prefix[site_prefix] = ip_prefix

    ip_prefix2site[ip_prefix] = site
    ip_prefix2site_prefix[ip_prefix] = site_prefix

    for i in range(5, len(comps)):
      #print comps[i]
      if site in site_neighbors:
        site_neighbors[site].append(comps[i])
      else:
        empty_list = []
        site_neighbors[site] = empty_list
        site_neighbors[site].append(comps[i])

#print site_neighbors
#print site2site_prefix
#print site_prefix2site
#print site2ip_prefix

