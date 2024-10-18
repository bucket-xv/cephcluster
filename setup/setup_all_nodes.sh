#!/bin/bash

manifest=$1
username=$2
omit=$3
host=''

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

while read -u10 line
do
  host="$line"
  scp_to_machine "$line"
done 10< ip_addr_host.txt

# this is to setup the servers
while read -u10 line
do
  scp_to_machine "$line"
  ssh -y -tt "$username@$line" "git clone git@github.com:Liu-Tzechinh/dRAID4Docker.git || (cd dRAID4Docker && git reset --hard HEAD && git pull)"
  
  if [ -z "$omit" ]; then
    ssh "$username@$line" "nohup ~/dRAID4Docker/setup/configure_ubuntu.sh > foo.out 2> foo.err < /dev/null &"
  else
    ssh "$username@$line" "cd ~/dRAID4Docker/test && make -j"
  fi
  echo "Uploaded to $line!"
done 10< ip_addrs_server.txt


echo "You are all set!"

