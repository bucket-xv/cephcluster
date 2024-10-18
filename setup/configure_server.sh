while read -r -u10 osd_ip hostname
do
    scp ~/.ssh/id_ed25519 "$osd_ip:~/.ssh/"
    sudo cat /etc/ceph/ceph.pub | ssh $osd_ip "sudo cat >> ~/.ssh/authorized_keys"
    ssh $osd_ip "sudo apt update && sudo apt install containerd && sudo apt install docker.io"
    sudo ssh-copy-id -f -i /etc/ceph/ceph.pub root@$osd_ip
    sudo ceph orch host add $hostname $osd_ip
done 10< ip_addrs_server.txt
