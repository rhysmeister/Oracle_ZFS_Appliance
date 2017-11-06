# Script to configure a replication action
# Need to add continuous & perhaps other options here
cd /
shares
select rhys
replication
action
set target=rhys
set pool=pool0
set continuous=true
commit
# last get id
done
