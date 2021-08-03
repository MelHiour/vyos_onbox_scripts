#!/bin/vbash

# This script logs number of unionfs-fuse mount points.

source /opt/vyatta/etc/functions/script-template

RUN_GRP='vyattacfg'

if [ "$(id -g -n)" != "${RUN_GRP}" ] ; then
    exec sg "${RUN_GRP}" -c "/bin/vbash $(readlink -f $0) $@"
fi

len=$(ps aux | grep -Fc unionfs-fuse)
logger "Number of unionfs-fuse mount points is ${len}"
exit
