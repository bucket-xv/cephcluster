cp /users/BucketXv/.ssh/id_ed25519 /root/.ssh/id_ed25519
while read -r -u10 osd_ip hostname
do
    scp ~/.ssh/id_ed25519 "$osd_ip:~/.ssh/"
    sudo cat /etc/ceph/ceph.pub | ssh $osd_ip "sudo cat >> ~/.ssh/authorized_keys"
    ssh $osd_ip "sudo apt update && sudo apt install containerd && sudo apt install docker.io"
    sudo -i
    ceph orch host add $hostname $osd_ip
    exit
done 10< ip_addrs_server.txt
