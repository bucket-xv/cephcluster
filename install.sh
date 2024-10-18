# for monitor node first
sudo -i
apt update
# mkfs.ext4 /dev/sda4
# mkdir /mnt/sda4
# mount --bind /var/lib/ceph /mnt/sda4
mount -t auto -v /dev/sda4 /var/lib/ceph
# mv /mnt/sda4/* /var/lib/ceph
umount /mnt/sda4

sudo apt update
CEPH_RELEASE=18.2.4
curl --silent --remote-name --location https://download.ceph.com/rpm-${CEPH_RELEASE}/el9/noarch/cephadm
chmod +x cephadm
sudo ./cephadm add-repo --release Reef
sudo ./cephadm install
sudo apt install python3.10
sudo cephadm add-repo --release reef
sudo cephadm install ceph-common
sudo cephadm bootstrap --mon-ip 128.105.145.216 --cleanup-on-failure --allow-fqdn-hostname
exit

# install


# for osd nodes
OSD_IP=10.10.1.3
cat /etc/ceph/ceph.pub | ssh $OSD_IP "sudo cat >> ~/.ssh/authorized_keys"
ssh $OSD_IP "apt update && apt install docker.io"
ceph orch host add server-2.bucketxv-221991.dstore-pg0.wisc.cloudlab.us $OSD_IP

# for clients
sudo apt update
CEPH_RELEASE=18.2.4
curl --silent --remote-name --location https://download.ceph.com/rpm-${CEPH_RELEASE}/el9/noarch/cephadm
chmod +x cephadm
sudo ./cephadm add-repo --release Reef
sudo ./cephadm install
sudo cephadm add-repo --release reef
sudo cephadm install ceph-common
MON_IP=128.105.145.216 
sudo touch /etc/ceph/ceph.conf
sudo touch /etc/ceph/ceph.client.admin.keyring
(ssh BucketXv@$MON_IP "sudo ceph config generate-minimal-conf") | sudo tee /etc/ceph/ceph.conf >/dev/null
(ssh BucketXv@$MON_IP "sudo cat /etc/ceph/ceph.client.admin.keyring") | sudo tee /etc/ceph/ceph.client.admin.keyring >/dev/null

# install wireshark
sudo apt-get update
# sudo apt install qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools
# sudo apt-get install wireshark
# sudo wireshark
sudo apt-get install tshark -y



