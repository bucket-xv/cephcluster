#!/bin/bash

# This is a script for Ubuntu 18
sudo apt update -y
sudo apt-get install gcc g++ make cmake git autogen autoconf automake yasm nasm libtool libboost-all-dev -y
sudo apt-get install -y help2man

cd ~/dRAID4Docker/
git submodule update --init --recursive

# These are to install the isa-l library
cd submodules/isa-l
./autogen.sh
./configure
make
sudo make install
cd ../..

# These are to install the spdk library
cd ../submodules/spdk
git submodule update --init
sudo ./scripts/pkgdep.sh
./configure
make
cd ../..

# install dependencies of Linux RAID
# sudo apt update -y
# sudo apt install nvme-cli -y
# sudo apt install mdadm -y
# sudo apt install libaio-dev -y
# sudo modprobe nvme-rdma
# sudo mkdir /raid
# install FIO
# git clone https://github.com/axboe/fio
# cd fio
# make
# sudo make install
# sudo ldconfig
cd ..