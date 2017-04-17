#!/usr/bin/python

import time
import BaseHTTPServer
import os
import time
import sys
#import html
#from terminaltables import AsciiTable
import process_topology as topo

Enable_NDN_RTT = 0 # Print NDN RTT if set to true

# Each
HOST_NAME = '128.252.153.28' # !!!REMEMBER TO CHANGE THIS!!!
PORT_NUMBER = 8080

PATH="../"
links_file_name = PATH
if topo.RUN_IN_ONL == 1:
  links_file_name += 'linksList' # ./ ---> ../linksList
else:
  links_file_name += 'linksList.testbed' # ./ ---> ../linksList.testbed

#key format: /name/prefix-192.168.1.1 (neighboring IP address)
key_id = dict()
id_key = dict()
id_rtt = dict()          # IP RTT
id_nlsr = dict()      # NLSR configuration values
id_ndn_rtt = dict()   # NDN RTT

if Enable_NDN_RTT == 1:
  table_data = [["Link ID", "Link", "NLSR", "IP RTT (ms)", "NDN RTT"]]
else:
  table_data = [["Link ID", "Link", "NLSR", "IP RTT (ms)"]]

update = 0
last_update = 0

def populate_id_rtt_table():
  f = open(links_file_name, 'r')
  for line in f:
    line = line.rstrip()
    comps = line.split(" ")
    key = topo.site_prefix2site[comps[1]] + " --> " + topo.ip_prefix2site[comps[2]]
    link_id = comps[0]

    key_id[key] = link_id
    id_key[int(link_id)] = key

    id_rtt[int(link_id)] = 0
    id_ndn_rtt[int(link_id)] = 0
    id_nlsr[int(link_id)] = 0

def populate_id_nlsr():
  f = open('./routers.with_costs', 'r')

  #"lip6:fr/lip6:ndnhub:h49x1:192.168.49.1:urjc:15:systemx:2:orange:3:basel:18:ntnu:25:mich:69"
  for line in f:
    if "\"" in line:
      line = line.rstrip()
      line = line.split('"')[1]
      line = line.split('"')[0]
      comps = line.split(':')

      site = comps[0]
      i = 5
      while i < len(comps):
        dest_site = comps[i]
        cost = comps[i+1]
        i = i+2

        key = site + " --> " + dest_site
        if key in key_id:
          link_id = key_id[key]
          id_nlsr[int(link_id)] = int(cost) * 2

def dump_rtt():
  processed = dict()
  #for link_id in range(1, len(id_rtt)):
  for link_id in id_rtt:
    key = id_key[link_id]
    if key not in processed:
      one_line = []
      one_line.append("{:<3}".format(str(link_id)))
      one_line.append("{:<20}".format(id_key[link_id].upper()))
      one_line.append("{:<10}".format(str(id_nlsr[link_id])))
      one_line.append("{:<10}".format(str(id_rtt[link_id])))
      if Enable_NDN_RTT == 1:
        one_line.append("{:<10}".format(str(id_ndn_rtt[link_id])))
      processed[key] = 1
      id_rtt[link_id] = 0

      #r_key = key.split(" --> ")[1] + " --> " + key.split(" --> ")[0]
      #r_id = int(key_id[r_key])
      #one_line.append("{:<3}".format(str(r_id)))
      #one_line.append("{:<20}".format(id_key[r_id].upper()))
      #one_line.append("{:<10}".format(str(id_rtt[r_id])))
      #processed[r_key] = 1
      #id_rtt[r_id] = 0

      print one_line
      #table_data.append(one_line)
      #table = AsciiTable(table_data)
  #print table.table

header=""
if Enable_NDN_RTT == 1:
  header = """ <!DOCTYPE html>
  <html lang="en">
  <head>
    <title> NDN Testbed RTT </title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
    <link rel="stylesheet" href="http://cdn.datatables.net/1.10.9/css/jquery.dataTables.min.css">
    <script src="http://cdn.datatables.net/1.10.9/js/jquery.dataTables.min.js"></script>
    <script type="text/javascript"
    src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
  </head>
  <body>

  <script>
  $(document).ready(function(){
      $('#myTable').DataTable();
  });
  </script>

  <br></br>
  <h3 align=center>NDN Testbed RTT Collection</h3>
  <p></p>

  <div class="table-responsive">
    <table id="myTable" class="display">
      <thead>
        <tr>
          <th class="col-sm-1">Link ID</th>
          <th class="col-sm-1">Link</th>
          <th class="col-sm-1">NLSR</th>
          <th class="col-sm-1">IP RTT</th>
          <th class="col-sm-2">NDN RTT</th>
        </tr>
      </thead>
  """
else:
  header = """ <!DOCTYPE html>
  <html lang="en">
  <head>
    <title> NDN Testbed RTT </title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
    <link rel="stylesheet" href="http://cdn.datatables.net/1.10.9/css/jquery.dataTables.min.css">
    <script src="http://cdn.datatables.net/1.10.9/js/jquery.dataTables.min.js"></script>
    <script type="text/javascript"
    src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
  </head>
  <body>

  <script>
  $(document).ready(function(){
      $('#myTable').DataTable();
  });
  </script>

  <br></br>
  <h3 align=center>NDN Testbed RTT Collection</h3>
  <p></p>

  <div class="table-responsive">
    <table id="myTable" class="display">
      <thead>
        <tr>
          <th class="col-sm-1">Link ID</th>
          <th class="col-sm-1">Link</th>
          <th class="col-sm-1">NLSR</th>
          <th class="col-sm-1">IP RTT</th>
        </tr>
      </thead>
  """


tailer = """ </table>
</div>
"""

def dump_rtt_html():
  table_code = ""
  table_code += '<tbody>\n'
  for link_id in id_rtt:
    table_code += '<tr>\n'
    table_code += '<td>'+str(link_id)+'</td>'
    table_code += '<td>'+id_key[link_id]+'</td>'
    table_code += '<td>'+str(id_nlsr[link_id])+'</td>'
    table_code += '<td>'+str(id_rtt[link_id])+'</td>'+"\n"
    if Enable_NDN_RTT == 1:
      table_code += '<td>'+str(id_ndn_rtt[link_id])+'</td>'+"\n"
    table_code += '</tr>\n'
  table_code += '</tbody>\n'

  return table_code

class MyHandler(BaseHTTPServer.BaseHTTPRequestHandler):
  def do_HEAD(s):
    s.send_response(200)
    s.send_header("Content-type", "text/html")
    s.end_headers()
  def do_GET(s):
    """Respond to a GET request."""

    if "/ipPing/" in s.path:
      msg = s.path.split("/ipPing/")[1]
      comps = msg.split("&")
      comps.pop(-1) # remove the last element

      for comp in comps:
        key = comp.split("+")[0]
        if key[0] != '/':
          key = "/" + key
        rtt = comp.split("+")[1]

        key_0 = key.split(":")[0]
        key_1 = key.split(":")[1]

        key_0 = topo.site_prefix2site[key_0]
        key_1 = topo.ip_prefix2site[key_1]

        key = key_0 + " --> " + key_1
        link_id = key_id[key]
        #print "link_id: ", link_id, " key: ", key
        id_rtt[int(link_id)] = rtt

      global update
      update = update + 1
      if update > 200:
      #if update > 10:
        os.system('clear')
        dump_rtt()
        update = 0

    if "/ndnPing" in s.path:
      msg = s.path.split("/ndnPing/")[1]
      comps = msg.split("&")
      comps.pop(-1) # remove the last element

      for comp in comps:
        key = comp.split("+")[0]
        if key[0] != '/':
          key = "/" + key
        rtt = comp.split("+")[1]

        key_0 = key.split(":")[0]
        key_1 = key.split(":")[1]

        key_0 = topo.site_prefix2site[key_0]
        key_1 = topo.ip_prefix2site[key_1]

        key = key_0 + " --> " + key_1
        link_id = key_id[key]
        id_ndn_rtt[int(link_id)] = rtt

        update = update + 1
        if update > 100:
          os.system('clear')
          dump_rtt()
          update = 0

    if "/get_ip_rtt.html" in s.path:
      s.send_response(200)
      s.send_header("Content-type", "text/html")
      s.end_headers()

      s.wfile.write(header)
      s.wfile.write(dump_rtt_html())
      s.wfile.write(tailer)

if __name__ == '__main__':

  populate_id_rtt_table()
  populate_id_nlsr()

  server_class = BaseHTTPServer.HTTPServer
  httpd = server_class((HOST_NAME, PORT_NUMBER), MyHandler)
  print time.asctime(), "Server Starts - %s:%s" % (HOST_NAME, PORT_NUMBER)
  try:
    httpd.serve_forever()
  except KeyboardInterrupt:
    pass
  httpd.server_close()
  print time.asctime(), "Server Stops - %s:%s" % (HOST_NAME, PORT_NUMBER)
