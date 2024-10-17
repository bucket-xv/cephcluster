#!/bin/bash

manifest=$1
username=$2
omit=$3

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
  ssh -y -tt "$username@$ip_addr" "mkdir ~/artifacts"
  scp ip_addr_host.txt "$username@$ip_addr:~/artifacts/"
  scp ip_addrs_server.txt "$username@$ip_addr:~/artifacts/"
  scp "$manifest" "$username@$ip_addr:~/artifacts/"
}

# this is to setup the host
while read -u10 line
do
  if [ -z "$omit" ]; then
    scp_to_machine "$line"
  fi
  ssh -y -tt "$username@$line" "git clone git@github.com:Liu-Tzechinh/dRAID4Docker.git || (cd dRAID4Docker && git reset --hard HEAD && git pull)"

  if [ -z "$omit" ]; then
    ssh "$username@$line" "nohup ~/dRAID4Docker/setup/configure_host.sh > foo.out 2> foo.err < /dev/null &"
  fi

  ssh "$username@$line" "cd ~/dRAID4Docker/test && make"
  echo "Uploaded to $line!"
done 10< ip_addr_host.txt

# this is to setup the servers
while read -u10 line
do
  if [ -z "$omit" ]; then
    scp_to_machine "$line"
  fi
  ssh -y -tt "$username@$line" "git clone git@github.com:Liu-Tzechinh/dRAID4Docker.git || (cd dRAID4Docker && git reset --hard HEAD && git pull)"
  
  if [ -z "$omit" ]; then
    ssh "$username@$line" "nohup ~/dRAID4Docker/setup/configure_server.sh > foo.out 2> foo.err < /dev/null &"
  fi

  ssh "$username@$line" "cd ~/dRAID4Docker/test && make"
  echo "Uploaded to $line!"
done 10< ip_addrs_server.txt

# check if all setups are ready
while read -u10 line
do
  while ssh "$username@$line" '[ ! -f ~/dRAID4Docker/test/bin/hello_world ]'
  do
    echo "Setup is ongoing on $line"
    sleep 5
  done
  echo "$line is ready!"
done 10< ip_addrs_server.txt

echo "You are all set!"

