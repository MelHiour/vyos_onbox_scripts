#!/bin/vbash

# There is an address-group called BRUTERS. This script is just parse the lenth of it and log this as a message. 

source /opt/vyatta/etc/functions/script-template

if [ "$(id -g -n)" != 'vyattacfg' ] ; then
    exec sg vyattacfg -c "/bin/vbash $(readlink -f $0) $@"
fi

_LENTH=$(run show conf commands | grep "group address-group BRUTERS address" | wc -l)
logger "BRUTERS address group lenth is $_LENTH"
exit
