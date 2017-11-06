# This script writes data to the rhys share. We only run this on one hostname
cd /
confirm shell
mkfile -n 1g /export/rhys/test1.file
mkfile -n 100m /export/rhys/test2.file
mkfile -n 256b /export/rhys/test3.file
