

Requirements
=============

packer - 1.1.1
VirtualBox - 5.1.30
expect - 5.45
Oracle ZFS Appliance Simulator OVF Image File for VirtualBox - http://www.oracle.com/technetwork/server-storage/sun-unified-storage/downloads/sun-simulator-1368816.html

Getting Started
================

- Ensure the Virtual machiens with the following names do not already exist in VirtualBox. The process will fail if they do.

packer-oracle-zfs1
packer-oracle-zfs2

- In the two packer json files change the source_path variable to the appliance ovf file (and any other variables you wish to change).

- Ensure the host only network vboxnet0 with the IP 192.168.47.1/24

- Execute the following command to build the boxes...

./create_ozfs_appliance_env.sh

- Go and make a coffee.


