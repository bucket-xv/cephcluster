#!/bin/bash

sudo apt update
sudo mkdir -p /var/lib/ceph
sudo mkfs.ext4 /dev/sda4
# mkdir /mnt/sda4
# mount --bind /var/lib/ceph /mnt/sda4
sudo mount -t auto -v /dev/sda4 /var/lib/ceph
# mv /mnt/sda4/* /var/lib/ceph
# sudo umount /mnt/sda4

cd ~
sudo apt install docker.io
sudo apt install software-properties-common -y
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt install python3.10
CEPH_RELEASE=18.2.4 
sudo curl --silent --remote-name --location https://download.ceph.com/rpm-${CEPH_RELEASE}/el9/noarch/cephadm
sudo chmod +x cephadm
sudo ./cephadm add-repo --release reef
sudo ./cephadm install
sudo cephadm add-repo --release reef
sudo cephadm install ceph-common
host=$(head -n 1 ip_addr_host.txt)
sudo cephadm bootstrap --mon-ip $host --cleanup-on-failure --allow-fqdn-hostname
sudo ceph orch apply osd --all-available-devices