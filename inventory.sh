#!/bin/bash

if [ "$1" == "get" ]; then
    curl -kn --silent https://whale:3000/inventory$2 | python -m json.tool
elif [ "$1" == "post" ]; then
    curl -kn --silent --header "Content-Type:application/json" --request POST --data $2 https://whale:3000/inventory$3 | python -m json.tool
elif [ "$1" == "put" ]; then
    curl -kn --silent --header "Content-Type:application/json" --request PUT --data $2 https://whale:3000/inventory$3 | python -m json.tool
elif [ "$1" == "delete" ]; then
    curl -kn --silent --header "Content-Type:application/json" --request DELETE https://whale:3000/inventory$2 | python -m json.tool
fi
