# for monitor node first
sudo -i
apt update
mkfs.ext4 /dev/sda4
mkdir /mnt/sda4
mount --bind /var/lib/docker /mnt/sda4
mount -t auto -v /dev/sda2 /var/lib/docker
mv /mnt/sda4/* /var/lib/docker
umount /mnt/sda4
sudo cephadm bootstrap --mon-ip 10.10.1.2 --cleanup-on-failure --allow-fqdn-hostname
exit

# install
sudo apt update
CEPH_RELEASE=18.2.4
curl --silent --remote-name --location https://download.ceph.com/rpm-${CEPH_RELEASE}/el9/noarch/cephadm
chmod +x cephadm
sudo ./cephadm add-repo --release Reef
sudo ./cephadm install
sudo cephadm add-repo --release reef
sudo cephadm install ceph-common

# for osd nodes
OSD_IP=10.10.1.3
cat /etc/ceph/ceph.pub | ssh $OSD_IP "sudo cat >> ~/.ssh/authorized_keys"
ssh $OSD_IP "apt update && apt install docker.io"
ceph orch host add server-2.bucketxv-221991.dstore-pg0.wisc.cloudlab.us $OSD_IP

# for clients
MON_IP=128.105.145.216 
(ssh BucketXv@$MON_IP "sudo ceph config generate-minimal-conf") | sudo tee -a /etc/ceph/ceph.conf >/dev/null
(ssh BucketXv@$MON_IP "sudo cat /etc/ceph/ceph.client.admin.keyring") | sudo tee -a /etc/ceph/ceph.client.admin.keyring >/dev/null



