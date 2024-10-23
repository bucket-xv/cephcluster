#!/bin/bash

# mount sda4 to /var/lib/ceph
sudo apt update
sudo mkdir -p /var/lib/ceph
sudo mkfs.ext4 /dev/sda4
sudo mount -t auto -v /dev/sda4 /var/lib/ceph

# install cephadm and ceph-common
cd ~
sudo apt install docker.io software-properties-common -y
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt install python3.10 -y
# CEPH_RELEASE=18.2.4 
CEPH_RELEASE=19.2.0
sudo curl --silent --remote-name --location https://download.ceph.com/rpm-${CEPH_RELEASE}/el9/noarch/cephadm
sudo chmod +x cephadm
sudo ./cephadm add-repo --release reef
sudo ./cephadm install
sudo cephadm add-repo --release reef
sudo cephadm install ceph-common
sudo cephadm install ceph-base

# cephadm bootstrap
cd ~/cephcluster/setup
host=$(head -n 1 ip_addr_host.txt)
sudo cephadm bootstrap --mon-ip $host --cleanup-on-failure --allow-fqdn-hostname
sudo ceph orch apply osd --all-available-devices