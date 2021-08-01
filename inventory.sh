#!/bin/bash

# This is a wrapper to query inventory API described in https://github.com/MelHiour/simple_api_inventory
# To make it work you need to
# - Have .netrc in your home directory
#    $ cat .netrc 
#    machine whale
#	    login melhiour
#	    password dfsjhsjdhfjd87erk
# - Store this script in /config/scripts/init.sh (if you use VyOS)
# - Fix permissions 
#    chmod +x /config/scripts/init.sh
# - Make a simlink 
#    sudo ln -s /config/scripts/inv.sh /usr/local/bin/inv
#
# Enjoy!
# $ inv get /
#   {"equipment": [
#        [
#            "novac",
#            "thiem"
#        ]
#    ]
#   }
# Usage:
# inv [get|post|put|delete] [json_data(put&post only)] [endpoint]
#
# Exampes:
# inv get /
# inv put '{"type":"VM","os":"Centos"}' /whale
# inv delete /novac

_INVENTORY_PATH=https://whale:3000/inventory

if [ "$1" == "get" ]; then
    curl -kn --silent $_INVENTORY_PATH$2 | python -m json.tool
elif [ "$1" == "post" ]; then
    curl -kn --silent --header "Content-Type:application/json" --request POST --data "$2" $_INVENTORY_PATH$3 | python -m json.tool            
elif [ "$1" == "put" ]; then
    curl -kn --silent --header "Content-Type:application/json" --request PUT --data "$2" $_INVENTORY_PATH$3 | python -m json.tool            
elif [ "$1" == "delete" ]; then
    curl -kn --silent --header "Content-Type:application/json" --request DELETE $_INVENTORY_PATH$2 | python -m json.tool    
else
    echo 'Operation is not supported. Please use [get|put|delete|post]'
fi
