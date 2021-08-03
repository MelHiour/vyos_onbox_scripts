#!/bin/bash

# This is a wrapper to query inventory API described in https://github.com/MelHiour/simple_api_inventory
# To make it work you need to
# - Have .netrc in your home directory
#    $ cat .netrc
#    machine whale
#        login melhiour
#        password dfsjhsjdhfjd87erk
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

set -f

need_args() {
    [ "$2" = "$3" ] && return
    echo "Action '$1' requires $2 arguments - got $3 instead" 1>&2
    exit 1
}

do_req() {
    curl -sSLkn "$@" | python -m json.tool
}

case "$1" in
get)
    need_args "$1" 2 $#
    do_req "${_INVENTORY_PATH}$2"
;;
post)
    need_args "$1" 3 $#
    do_req "${_INVENTORY_PATH}$3" -X POST -H "Content-Type: application/json" --data "$2"
;;
put)
    need_args "$1" 3 $#
    do_req "${_INVENTORY_PATH}$3" -X PUT -H "Content-Type: application/json" --data "$2"
;;
delete)
    need_args "$1" 2 $#
    do_req "${_INVENTORY_PATH}$2" -X DELETE -H "Content-Type: application/json"
;;
*)
    echo 'Operation is not supported. Please use [get|put|delete|post]' 1>&2
    exit 1
;;
esac
