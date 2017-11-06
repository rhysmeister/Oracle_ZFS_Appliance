# The target host must be up and contactable for this script to succeed
# We do this only source -> target
cd /
configuration
services
replication
targets
target
set hostname=192.168.47.111
set root_password=secret
set label=rhys
commit
exit
