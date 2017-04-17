#!/usr/bin/python
import sys, os

site = sys.argv[1]
site = site.split("/")
site_names = os.listdir("./NLSR_CONF")

for i in site:
    for j in site_names:
       j = j.split(".")
       if i == j[0]:
           the_site = j[0]
    
print the_site

conf_file = open("./NLSR_CONF/%s.conf" % the_site)
neighbors_list = []


for line in conf_file:
    if "neighbor  ;" in line:
        line = line.strip()
        neighbor = line.split(";") 
        neighbors_list.append(neighbor[1])

print neighbors_list
