#!/bin/vbash

# This script parses log messages with "Failed password for invalid user"
# and "Failed password for root" messages, extracts IP addresses
# and updates the address-group called BRUTERS.
# The address group will be added to block SSH Brute-force.

source /opt/vyatta/etc/functions/script-template

RUN_GRP='vyattacfg'
CFG_GRP='BRUTERS'

if [ "$(id -g -n)" != "${RUN_GRP}" ] ; then
    exec sg "${RUN_GRP}" -c "/bin/vbash $(readlink -f $0) $@"
fi

ts=$(date +"%d-%m-%y-%T")
# TODO:
# - write precise regex for IPv4 addresses
# - also grep IPv6 addresses
# - merge with previous list in case of /var/log/messages log rotation
# - maybe look into /var/log/btmp instead of /var/log/messages or use both?..
# - unblock criteria
# - 'allowlist' support
list=$(grep -E "Failed password for (root|invalid user)" /var/log/messages | grep -Eo '([0-9]{1,3}[\.]){3}[0-9]{1,3}' | sort | uniq)

if [ -z "${list}" ] ; then
    logger "${CFG_GRP}-UPDATER: no IP addresses has been found in logs. Finishing."
    exit 0
fi

configure
delete firewall group address-group "${CFG_GRP}"
set firewall group address-group "${CFG_GRP}" description "${ts}"

for i in ${list} ; do
    set firewall group address-group "${CFG_GRP}" address "$i"
done

commit comment "${CFG_GRP} update at ${ts}"

logger "${CFG_GRP}-UPDATER: address group has been updated."
