#!/bin/bash
_INVENTORY_PATH=https://whale:3000/inventory

if [ "$1" == "get" ]; then
    curl -kn --silent $_INVENTORY_PATH$2 | python -m json.tool
elif [ "$1" == "post" ]; then
    curl -kn --silent --header "Content-Type:application/json" --request POST --data $2 $_INVENTORY_PATH$3 | python -m json.tool            
elif [ "$1" == "put" ]; then
    curl -kn --silent --header "Content-Type:application/json" --request PUT --data $2 $_INVENTORY_PATH$3 | python -m json.tool            
elif [ "$1" == "delete" ]; then
    curl -kn --silent --header "Content-Type:application/json" --request DELETE $_INVENTORY_PATH$2 | python -m json.tool            
fi
