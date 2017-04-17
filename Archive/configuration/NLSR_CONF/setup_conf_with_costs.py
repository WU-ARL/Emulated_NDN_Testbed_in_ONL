#/usr/bin/python

from __future__ import print_function
import re,sys

# for happy
import pprint

# put something with this structure in to seperate file
# pull out structure in python with .split(':') and put in dict
# NLSR_PAIRING=( 
#           mccoy:colostate:h1x1:192.168.1.1:ndnx:ndn0:hobo
#           ndnx:illinois:h2x1:192.168.2.1:mccoy:ndn0:wundngw
#           ndn0:umich:h3x1:192.168.3.1:mccoy:wundngw:titan
#           titan:memphis:h5x2:192.168.5.2:ndn0:wundngw:hobo
#           wundngw:wustl:h6x1:192.168.6.1:hobo:titan:ndnx
#           hobo:arizona:h7x2:192.168.7.2:wundngw:mccoy:titan

routers = []

neighbor_string = """
   neighbor  ; sitename
   {
       name /ndn/site_extension/%C1.Router/router_extension       ; name prefix of the neighbor router consists
                                            ; of network, site-extension and router-extension
       face-uri  udp4://routerip                 ; face id of the face connected to the neighbor
       link-cost LCOST                         ; cost of the connecting link to neighbor
   }
"""

def read_network_config():
    # the file is formatted to be easy for bash to use,
    # so the python parsing is not as basic as it could be
    #print("read_network_config()")
    router_file = open("../routers.with_costs", "r")

    for line in router_file:
        # get string between 2 quotes
        single_router = re.search("\"(.*)\"", line)
        
        if single_router:
            router_info = single_router.group(1).split(':')
            router_object = {'sitename':router_info[0],
                             'site_extension':router_info[1],
                             'router_extension':router_info[2],
                             'hostalias':router_info[3],
                             'routerip':router_info[4]}
            # allows for any number of neighbors
            # adds each neighbor starting at index greater than 4 which skips over the 
            # router info fields to the start of the neighbor fields. Perhaps if we add
            # another condition that also says idx must be even and add costs after the router
            # then we can build a neighbors array and a costs array.
            neighbors = [x for idx, x in enumerate(router_info) if ((idx > 4) and (idx % 2))]
            costs = [x for idx, x in enumerate(router_info) if ((idx > 4) and not (idx % 2))]
            #print ("costs")
            #print (costs)
            #print ("end costs")
            router_object['neighbors'] = neighbors
            router_object['costs'] = costs

            # insert info in to routers array
            routers.append(router_object)
    #print("read_network_config() end")

def get_object_with_value(neighbor):
    for x in routers:
        if x['sitename'] == neighbor:
            return x
    else:
        print("Neighbor %s is not in your configuration", neighbor)
        sys.exit(2)

def setup_neighbors(router):
    return_str = ""
    count = 0
    costs = router['costs']
    for neighbor in router['neighbors']:
        # copy neighbor string template
        temp_str = neighbor_string
        # find necessary information about the specified router
        neighbor_info = get_object_with_value(neighbor)
        # replace necessary information from template string and add to return_str
        temp_str = re.sub(r'site_extension',neighbor_info['site_extension'], temp_str)
        temp_str = re.sub(r'router_extension',neighbor_info['router_extension'], temp_str)
        temp_str = re.sub(r'routerip',neighbor_info['routerip'], temp_str)
        temp_str = re.sub(r'LCOST',costs[count], temp_str)
        count = count + 1
        return_str += temp_str
    return return_str

def process(keyword, router):
    keywords = ["site_extension", "router_extension", "neighbors"]

    if keyword in keywords:
        if keyword == "site_extension" or keyword == "router_extension":
            return router[keyword]
        if keyword == "neighbors":
            return setup_neighbors(router)
    else:
        print("invalid keyword:",keyword)
        sys.exit(1)

def write_files():
    for router in routers:
        output = open(router['sitename']+'.conf', "w")
        template = open("../template.conf", "r")

        for line in template:
            line = line.rstrip('\n')
            # returns null if no match
            match = re.search("(.*)\!\!(.*)\!\!(.*)", line)
            if match:
                # Process the parenthesized subgroup (whatever is between the bangs)
                replacement = process(match.group(2), router)
                # add back in anything before/after the bangs
                replacement = match.group(1) + replacement + match.group(3)
                print(replacement, file=output,)
            else:
                print(line, file=output,)

def main():
    #print("main()")
    # Fills in 'routers' array based on information from 'routers' file in pwd 
    read_network_config()
    # create and write to .conf files
    write_files()
    

if __name__ == "__main__":
    main()

