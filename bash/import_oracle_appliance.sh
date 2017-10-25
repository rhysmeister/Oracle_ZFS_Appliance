#!/bin/sh
# Based on the ideas found at http://ebarnouflant.com/posts/7-convert-a-virtualbox-ova-vm-into-a-vagrant-box
# This script aims to provide a idempotent way to import to Oracle Unified Storage Simulator instances
# Found at http://www.oracle.com/technetwork/server-storage/sun-unified-storage/downloads/sun-simulator-1368816.html
# We must do the import, rather than creating a box, the import generates a unique id that must be
# different in order to setup replication.
# Boxes will clone this uuid and replication between the hosts does not work
set -e;
set -u;
set -x;

OVF_FILE_PATH="/Users/rhys1/Downloads/OS8.7VirtualBox/OS8.7VirtualBox.ovf";
INSTANCES=$(VBoxManage list vms | grep OracleZFS | wc -l);
LOG_FILE="ozfs_import.log";

function finish() {
    S=$?;
    if [ "$S" -eq 0 ]; then
      echo "The script executed without error" && exit 0;
    else
      echo "There was an error. Check log: $LOG_FILE" && exit "$S";
    fi;
}
trap finish EXIT;

if [[ ${INSTANCES} -eq 0 ]]; then
   VBoxManage import "$OVF_FILE_PATH" --vsys 0 --vmname OracleZFS1 --eula accept >> "$LOG_FILE" 2>&1;
   VBoxManage import "$OVF_FILE_PATH" --vsys 0 --vmname OracleZFS2 --eula accept >> "$LOG_FILE" 2>&1;
   echo "Successfully imported two instances of $OVF_FILE_PATH";
   exit 0;
elif [[ ${INSTANCES} -eq 2 ]]; then
  echo "2 OracleZFS instances present on this host. Exiting without error";
  exit 0;
else
  echo "There are $INSTANCES of the OracleZFS VM present on this host. I will only create new OracleZFS instances when 0 exist.";
  exit 1;
fi;
