#!/bin/bash -vx

# setup hosts
# NOTE: the hostname seems to already be set at least on BioNimubs OS

sudo mkdir -p -m 1777 /mnt
sudo mount -t glusterfs master:/glustershare /mnt
sudo echo -e "master:/glustershare\t/mnt\tglusterfs\tdefaults,_netdev\t0\t0" >> /etc/fstab
echo "Worker done"
