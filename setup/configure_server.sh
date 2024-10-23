while read -r -u10 osd_ip
do
    ssh -o StrictHostKeyChecking=no $osd_ip "echo Hello!"
    scp ~/.ssh/id_ed25519 "$osd_ip:~/.ssh/"
    sudo cat /etc/ceph/ceph.pub | ssh $osd_ip "sudo cat >> ~/.ssh/authorized_keys"
    ssh $osd_ip "sudo mkdir -p /var/lib/ceph && sudo mkfs.ext4 /dev/sda4 && sudo mount -t auto -v /dev/sda4 /var/lib/ceph"
    ssh $osd_ip "sudo apt update && sudo apt install containerd -y && sudo apt install docker.io -y"
    sudo ssh-copy-id -f -i /etc/ceph/ceph.pub root@$osd_ip
    hostname=$(ssh $osd_ip hostname)
    sudo ceph orch host add $hostname $osd_ip
done 10< ip_addrs_server.txt
