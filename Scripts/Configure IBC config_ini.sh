#!/bin/bash

ibc_configuration=$HOME/Library/Mobile\ Documents/com~apple~CloudDocs/Developer/mpib/ignore/config.ini
config_file=$HOME/ibc/config.ini
while IFS='=' read -r key value; do
    if [[ -n $value ]]; then
        sed -i '' "s/^$key=.*/$key=$value/" "$config_file"
    fi
done < <(grep -F -f <(cut -d'=' -f1 "$ibc_configuration") "$ibc_configuration")
