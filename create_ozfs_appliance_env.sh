#!/bin/bash
packer build packer-oracle-zfs-appliance1.json && echo "Finished building appliance #1";
rmdir output-virtualbox-ovf && echo "Removed unneeded empty output directory";
packer build packer-oracle-zfs-appliance2.json && echo "Finished building appliance #2";
rmdir output-virtualbox-ovf && echo "Removed unneeded empty output directory";
sleep 60 && echo "Sleeping for 60 seconds";

# Start the vms up again
VBoxManage startvm "packer-oracle-zfs1";
VBoxManage startvm "packer-oracle-zfs2";

# Sleep for a bit
sleep 120

# Configure the appliances
ozfs_config_scripts/1-create_pool.exp 192.168.47.110;
ozfs_config_scripts/1-create_pool.exp 192.168.47.111;

ozfs_config_scripts/2-create_project.exp 192.168.47.110;
ozfs_config_scripts/2-create_project.exp 192.168.47.111;

ozfs_config_scripts/3-create_filesystem.exp 192.168.47.110;
ozfs_config_scripts/3-create_filesystem.exp 192.168.47.111;

# Replication setup from A->B
ozfs_config_scripts/4-create_replication_target.exp 192.168.47.110 192.168.47.111;

ozfs_config_scripts/5-create_replication_action.exp 192.168.47.110;

ozfs_config_scripts/6-create_test_data.exp 192.168.47.110;
