# CloudLab Testbed Setup

This folder is used to setup the necessary dependency on the experiment machines.
Host dependency should be installed via `configure_host.sh` while server dependency should
be installed via `configure_server.sh`

## Setup the Testbed

1. Copy the manifest to manifest.xml and execute the following command
```Bash
python parse_manifest.py manifest.xml ip_addr_host.txt ip_addrs_server.txt
git commit -a -m "Change ip"
git push
```

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