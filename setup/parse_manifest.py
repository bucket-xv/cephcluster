import xml.etree.ElementTree as ET
import os
import json
import sys

if __name__ == '__main__':
    tree = ET.parse(sys.argv[1])
    host_file = open(sys.argv[2], "w")
    server_file = open(sys.argv[3], "w")
    root = tree.getroot()
    ipv4_addrs = []
    for child in root.iter():
        if child.tag.endswith('host'):
            ipv4_addrs.append(child.get('ipv4')+' '+child.get('name'))
            
    print(ipv4_addrs)
    host_file.write(ipv4_addrs[0] + '\n')
    for server in ipv4_addrs[1:]:
        server_file.write(server + '\n')
   
    host_file.close()
    server_file.close()
