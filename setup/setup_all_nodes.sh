#!/bin/bash

username=$1

# generate ip addresses from manifest, this is yet to be implemented
# line=`python3 parse_manifest.py ${manifest} hosts.txt ip_addrs_100g.txt ip_addrs_25g.txt`

scp_to_machine() {
  # Check if an argument is provided
  if [ $# -eq 0 ]; then
    echo "No argument provided"
    return 1
  fi

  ip_addr=$1

  echo "scp manifests to $ip_addr"
  scp ~/.ssh/id_ed25519 "$username@$ip_addr:~/.ssh/"
}

python parse_manifest.py manifest.xml ip_addr_host.txt ip_addrs_server.txt

while read -u10 -r line name
do
  scp_to_machine "$line"
done 10< ip_addr_host.txt

# this is to setup the servers
while read -u10 -r line name
do
  scp_to_machine "$line"
done 10< ip_addrs_server.txt


echo "You are all set!"

