
# for osd nodes


# for clients
sudo apt update
CEPH_RELEASE=18.2.4 curl --silent --remote-name --location https://download.ceph.com/rpm-${CEPH_RELEASE}/el9/noarch/cephadm
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



