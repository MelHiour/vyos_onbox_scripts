#!/bin/vbash
source /opt/vyatta/etc/functions/script-template

if [ "$(id -g -n)" != 'vyattacfg' ] ; then
    exec sg vyattacfg -c "/bin/vbash $(readlink -f $0) $@"
fi

_DATE=$(date +"%d-%m-%y-%T")
_IPLIST=$(egrep "(Failed password for invalid user|Failed password for root)" /var/log/messages | egrep -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" | sort | uniq | head -400)

if [ -z "$_IPLIST" ]
    then
        logger "BRUTERS-UPDATER. No IP addresses has been found in logs. Finishing."
    else
        ####
        configure
        delete firewall group address-group BRUTERS
        set firewall group address-group BRUTERS description $_DATE
        ####
        for _ADDRESS in $_IPLIST
          ####
          do set firewall group address-group BRUTERS address $_ADDRESS
          ####
          done
        ####
        commit comment 'BRUTERS update'
        ####
        logger "BRUTERS-UPDATER. Address group has been updated."
fi
exit
