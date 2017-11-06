#!/bin/bash
packer build packer-oracle-zfs-appliance1.json && echo "Finished building appliance #1";
rmdir output-virtualbox-ovf && echo "Removed unneeded empty output file";
packer build packer-oracle-zfs-appliance2.json && echo "Finished building appliance #2";
rmdir output-virtualbox-ovf && echo "Removed unneeded empty output file";
sleep 60 && echo "Sleeping for 60 seconds";

# Runs a script against
function run_ozfs_script() {
    HOST=$1;
    SCRIPT=$2;
    expect <<- EOF
      ssh root@$HOST < $SCRIPT
      expect ': $'
      send 'secret\r'
EOF
}

# Start the vms up again
VBoxManage startvm "packer-oracle-zfs1";
VBoxManage startvm "packer-oracle-zfs2";

# Configure the appliances
run_ozfs_script 192.168.47.110 ozfs_config_scripts/1-create_pool.ksh;
run_ozfs_script 192.168.47.111 ozfs_config_scripts/1-create_pool.ksh;

run_ozfs_script 192.168.47.110 ozfs_config_scripts/2-create_project.ksh;
run_ozfs_script 192.168.47.111 ozfs_config_scripts/2-create_project.ksh;

run_ozfs_script 192.168.47.110 ozfs_config_scripts/3-create_filesystem.ksh;
run_ozfs_script 192.168.47.111 ozfs_config_scripts/3-create_filesystem.ksh;

run_ozfs_script 192.168.47.110 ozfs_config_scripts/4-create_replication_target.ksh

run_ozfs_script 192.168.47.110 ozfs_config_scripts/5-create_replication_action.ksh

run_ozfs_script 192.168.47.110 ozfs_config_scripts/6-create_test_data.ksh
