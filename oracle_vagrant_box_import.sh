#!/bin/bash
# Import Oracle ovf file as a vagrant box. Not sure if this allows replication
# between instances as I suspect the ids might be cloned
# This box, once available, can be used with standard vagrant code
# Vagrant.configure("2") do |config|
#  config.vm.box = "OracleZFS"
#  # ...
# end
#
#
set -e;
set -u;
set -x;

OVF_FILE_PATH="/Users/rhys1/Downloads/OS8.7VirtualBox/OS8.7VirtualBox.ovf";
LOG_FILE="ozfs_vagrant_box_import.log";

function finish() {
    S=$?;
    if [ "$S" -eq 0 ]; then
      echo "The script executed without error" && exit 0;
    else
      echo "There was an error. Check log: $LOG_FILE" && exit "$S";
    fi;
}
trap finish EXIT;

BOX=$(vagrant box list | grep OracleZFS | wc -l);

if [ "$BOX" -eq 0 ]; then # Import and create the box

  INSTANCES=$(VBoxManage list vms | grep OracleZFS_BOX | wc -l);
  if [ "$INSTANCES" -eq 0 ]; then
    VBoxManage import "$OVF_FILE_PATH" --vsys 0 --vmname OracleZFS_BOX --eula accept >> "$LOG_FILE" 2>&1;
  fi;
  # Get the ID we need
  ID=$(VBoxManage list vms | grep OracleZFS_BOX| cut -d "{" -f2 | cut -d "}" -f1);
  # Package the vm as a vagrant box
  vagrant package --base "$ID" --output OracleZFS.box;
  vagrant box add OracleZFS.box --name OracleZFS;
elif [ "$BOX" -eq 1 ]; then
  echo "Box already exists. Exiting cleanly."
  exit 0;
else
  echo "Something is wrong. There are $BOX boxes";
  exit 1;
fi;
