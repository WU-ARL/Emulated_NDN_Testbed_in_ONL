#!/usr/bin/env python
import sys


links={}
nodes={}
nodesSWR={}
nodesPort={}
nodesSubnet={}

def process_nodes():
  #print "process_nodes():"
  f = open('nodes.lint','r')

  line = f.readline()

  #print "line: ", line
  count=0
  while line != '' :
    words = line.split()
    # words[0]: should be comment mark <!--
    # words[1]: should be node name
    # words[2]: should be SWR label
    # words[3]: should be port number
    # words[4]: should be h#x# hostname
    # words[5]: should be IP Address
    # words[6]: should be 24 bit subnet
    # words[7]: should be end of comment mark -->
    #print "Node (words[1]): ", words[1]
    nodes[count]=words[1]
    nodesSWR[words[1]]=words[2]
    nodesPort[words[1]]=words[3]
    nodesSubnet[words[1]]=words[6]
    line = f.readline()
   
def process_links():
  #print "process_links():"
  f = open('links.lint','r')

  line = f.readline()

  #print "line: ", line
  count=0
  while line != '' :
    words = line.split()
    # words[0]: should be comment mark <!--
    # words[1]: should be start node name
    # words[2]: should be end node name
    # words[3]: should be cost
    # words[4]: should be end of comment mark -->
    #print "Link (words[1], words[2], words[3]): ", words[1], words[2], words[3]
    link = (words[1], words[2])
    links[link] = words[3]
    line = f.readline()

def addQueue(swr, port, qid, delay):
    sys.stdout.write('<batchCommand>')
    sys.stdout.write('<!-- %s: Queues -->' % (swr))
    sys.stdout.write('<component typeName="table">')
    sys.stdout.write('<label>%s:port%s:QueueTable</label>' %(swr,port))
    sys.stdout.write('</component>')
    sys.stdout.write('<tableElement>')
    sys.stdout.write('<entry generated="false">')
    sys.stdout.write('<field fieldName="queue_id">%s</field>' % (qid))
    sys.stdout.write('<field fieldName="rate in Kbps">1000</field>')
    sys.stdout.write('<field fieldName="burst in Kbps">1500</field>')
    sys.stdout.write('<field fieldName="mtu">1500</field>')
    sys.stdout.write('<field fieldName="delay in ms">%s</field>' % (delay))
    sys.stdout.write('<field fieldName="jitter in ms">0</field>')
    sys.stdout.write('<field fieldName="loss percentage">0</field>')
    sys.stdout.write('<field fieldName="corruption percentage">0</field>')
    sys.stdout.write('<field fieldName="duplicate percentage">0</field>')
    sys.stdout.write('</entry>')
    sys.stdout.write('</tableElement>')
    sys.stdout.write('<command displayLabel="Add Queue" opcode="87" numParams="9">')
    sys.stdout.write('<param plabel="queue_id">')
    sys.stdout.write('<default>%s</default>' % (qid))
    sys.stdout.write('</param>')
    sys.stdout.write('<param plabel="rate in Kbps">')
    sys.stdout.write('<default>1000</default>')
    sys.stdout.write('</param>')
    sys.stdout.write('<param plabel="burst in Kbps">')
    sys.stdout.write('<default>1500</default>')
    sys.stdout.write('</param>')
    sys.stdout.write('<param plabel="mtu">')
    sys.stdout.write('<default>1500</default>')
    sys.stdout.write('</param>')
    sys.stdout.write('<param plabel="delay in ms">')
    sys.stdout.write('<default>%s</default>' % (delay))
    sys.stdout.write('</param>')
    sys.stdout.write('<param plabel="jitter in ms">')
    sys.stdout.write('<default>0</default>')
    sys.stdout.write('</param>')
    sys.stdout.write('<param plabel="loss percentage">')
    sys.stdout.write('<default>0</default>')
    sys.stdout.write('</param>')
    sys.stdout.write('<param plabel="corruption percentage">')
    sys.stdout.write('<default>0</default>')
    sys.stdout.write('</param>')
    sys.stdout.write('<param plabel="duplicate percentage">')
    sys.stdout.write('<default>0</default>')
    sys.stdout.write('</param>')
    sys.stdout.write('</command>')
    sys.stdout.write('</batchCommand>')


def addFilter(swr, port, qid, daddr, saddr):
    #print "addFilter: swr port qid daddr saddr"
    #print "addFilter(", swr, port, qid, daddr, saddr, " )"
    sys.stdout.write('<batchCommand>')
    sys.stdout.write('<component typeName=\"table\">')
    sys.stdout.write('<!-- %s: Filters -->' % (swr))
    sys.stdout.write('<label>%s:FilterTable</label>' % (swr))
    sys.stdout.write('</component>')
    sys.stdout.write('<tableElement>')
    sys.stdout.write('<entry generated="false">')
    sys.stdout.write('<field fieldName="destination_address">%s</field>' % (daddr))
    sys.stdout.write('<field fieldName="destination_mask">24</field>')
    sys.stdout.write('<field fieldName="source_address">%s</field>' % (saddr))
    sys.stdout.write('<field fieldName="source_mask">24</field>')
    sys.stdout.write('<field fieldName="protocol">*</field>')
    sys.stdout.write('<field fieldName="destination_port">*</field>')
    sys.stdout.write('<field fieldName="source_port">*</field>')
    sys.stdout.write('<field fieldName="tcp fin">*</field>')
    sys.stdout.write('<field fieldName="tcp syn">*</field>')
    sys.stdout.write('<field fieldName="tcp rst">*</field>')
    sys.stdout.write('<field fieldName="tcp psh">*</field>')
    sys.stdout.write('<field fieldName="tcp ack">*</field>')
    sys.stdout.write('<field fieldName="tcp urg">*</field>')
    sys.stdout.write('<field fieldName="drop">false</field>')
    sys.stdout.write('<field fieldName="output_ports">%s</field>' % (port))
    sys.stdout.write('<field fieldName="sampling_rate">1</field>')
    sys.stdout.write('<field fieldName="qid">%s</field>' % (qid))
    sys.stdout.write('<field fieldName="enabled">true</field>')
    sys.stdout.write('</entry>')
    sys.stdout.write('</tableElement>')
    sys.stdout.write('<command displayLabel="AddFilter" opcode="77" numParams="17">')
    sys.stdout.write('<param plabel="destination_address">')
    sys.stdout.write('<default>%s</default>' % (daddr))
    sys.stdout.write('</param>')
    sys.stdout.write('<param plabel="destination_mask">')
    sys.stdout.write('<default>24</default>')
    sys.stdout.write('</param>')
    sys.stdout.write('<param plabel="source_address">')
    sys.stdout.write('<default>%s</default>' % (saddr))
    sys.stdout.write('</param>')
    sys.stdout.write('<param plabel="source_mask">')
    sys.stdout.write('<default>24</default>')
    sys.stdout.write('</param>')
    sys.stdout.write('<param plabel="protocol">')
    sys.stdout.write('<default>*</default>')
    sys.stdout.write('</param>')
    sys.stdout.write('<param plabel="destination_port">')
    sys.stdout.write('<default>*</default>')
    sys.stdout.write('</param>')
    sys.stdout.write('<param plabel="source_port">')
    sys.stdout.write('<default>*</default>')
    sys.stdout.write('</param>')
    sys.stdout.write('<param plabel="tcp fin">')
    sys.stdout.write('<default>*</default>')
    sys.stdout.write('</param>')
    sys.stdout.write('<param plabel="tcp syn">')
    sys.stdout.write('<default>*</default>')
    sys.stdout.write('</param>')
    sys.stdout.write('<param plabel="tcp rst">')
    sys.stdout.write('<default>*</default>')
    sys.stdout.write('</param>')
    sys.stdout.write('<param plabel="tcp psh">')
    sys.stdout.write('<default>*</default>')
    sys.stdout.write('</param>')
    sys.stdout.write('<param plabel="tcp ack">')
    sys.stdout.write('<default>*</default>')
    sys.stdout.write('</param>')
    sys.stdout.write('<param plabel="tcp urg">')
    sys.stdout.write('<default>*</default>')
    sys.stdout.write('</param>')
    sys.stdout.write('<param plabel="drop">')
    sys.stdout.write('<default>false</default>')
    sys.stdout.write('</param>')
    sys.stdout.write('<param plabel="output_ports">')
    sys.stdout.write('<default>%s</default>' % (port))
    sys.stdout.write('</param>')
    sys.stdout.write('<param plabel="sampling_rate">')
    sys.stdout.write('<default>1</default>')
    sys.stdout.write('</param>')
    sys.stdout.write('<param plabel="qid">')
    sys.stdout.write('<default>%s</default>' % (qid))
    sys.stdout.write('</param>')
    sys.stdout.write('</command>')
    sys.stdout.write('</batchCommand>')


if __name__ == '__main__':

    process_links()
    process_nodes()

    qid=10
    sys.stdout.write('<?xml version="1.0" ?>')
    sys.stdout.write('<batch>')
    for (n1,n2),cost in links.iteritems():
        #print "Link: ", n1, " -- ", n2, " cost: ", cost
        #print "Add queue qid=", qid, " on SWR=", nodesSWR[n1], " port=", nodesPort[n1], " with delay=", cost
        #print "Add filter on SWR=", nodesSWR[n1], " daddr 24 bit subnet = ", nodesSubnet[n1], " saddr 24 bit subnet = ", nodesSubnet[n2], " qid = ", qid, " output port = ", nodesPort[n1]
        addQueue(nodesSWR[n1], nodesPort[n1], qid, cost)
        addFilter(nodesSWR[n1], nodesPort[n1], qid, nodesSubnet[n1], nodesSubnet[n2])
        qid = qid + 1
        #print "Add queue qid=", qid, " on SWR=", nodesSWR[n2], " port=", nodesPort[n2], " with delay=", cost
        #print "Add filter on SWR=", nodesSWR[n2], " daddr 24 bit subnet = ", nodesSubnet[n2], " saddr 24 bit subnet = ", nodesSubnet[n1], " qid = ", qid, " output port = ", nodesPort[n2]
        addQueue(nodesSWR[n2], nodesPort[n2], qid, cost)
        addFilter(nodesSWR[n2], nodesPort[n2], qid, nodesSubnet[n2], nodesSubnet[n1])
        qid = qid + 1
        #print ""

    sys.stdout.write('</batch>')


