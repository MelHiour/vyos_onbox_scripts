#!/bin/vbash

# There is an address-group called BRUTERS.
# This script just parses it's length and logs this as a message.

source /opt/vyatta/etc/functions/script-template

RUN_GRP='vyattacfg'
CFG_GRP='BRUTERS'

if [ "$(id -g -n)" != "${RUN_GRP}" ] ; then
    exec sg "${RUN_GRP}" -c "/bin/vbash $(readlink -f $0) $@"
fi

len=$(run show conf commands | grep -Fc "group address-group ${CFG_GRP} address")
logger "${CFG_GRP} address group length is ${len}"
exit
