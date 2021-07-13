#!/bin/vbash

# This script logs unionfs-fuse mount point counts. 

source /opt/vyatta/etc/functions/script-template

if [ "$(id -g -n)" != 'vyattacfg' ] ; then
    exec sg vyattacfg -c "/bin/vbash $(readlink -f $0) $@"
fi

_LENTH=$(ps aux | grep unionfs-fuse | wc -l)
logger "Number of unionfs-fuse mount points is $_LENTH"
exit
