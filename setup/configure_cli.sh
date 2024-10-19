#!/bin/bash
while read -u10 -r line name
do
  sudo touch /etc/ceph/ceph.conf
  sudo touch /etc/ceph/ceph.client.admin.keyring
  (ssh BucketXv@$line "sudo ceph config generate-minimal-conf") | sudo tee /etc/ceph/ceph.conf >/dev/null
  (ssh BucketXv@$line "sudo cat /etc/ceph/ceph.client.admin.keyring") | sudo tee /etc/ceph/ceph.client.admin.keyring >/dev/null
done 10< ip_addr_host.txt
