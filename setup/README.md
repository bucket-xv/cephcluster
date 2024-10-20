# CloudLab Testbed Setup

This folder is used to setup the necessary dependency on the experiment machines.
Host dependency should be installed via `configure_host.sh` while server dependency should
be installed via `configure_server.sh`

## Setup the Testbed

1. Copy all the host and server IP addresses to `ip_addr_host.txt` and `ip_addrs_server.txt`. We plan to extract the IP addresses from `manifest.xml` in the future, but currently we have to manually write ip addresses to these two files.\
**Important Note!!!!** There **must** be an empty line after all the IP addresses.\

2. Run the following command to setup
```Bash
# Make sure you are under setup/
./setup_all_nodes.sh BucketXv
```

3. ssh to host machine and git clone and operate

```Bash
git clone git@github.com:bucket-xv/cephcluster.git
cd cephcluster/setup
./configure_host.sh
./configure_server.sh
```
4. Consider creating a pool?
    
```Bash
./create_ecpool.sh
```