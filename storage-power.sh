#!/bin/bash

declare -a STORAGE_POWER_DRAW
STORAGE_POWER_DRAW["Solid-State-Device"]=4.2
STORAGE_POWER_DRAW["15000"]=6.5
STORAGE_POWER_DRAW["10000"]=5.8
STORAGE_POWER_DRAW["7200"]=8

export ELEMENTO_POWER_STORAGE=0
STORAGE_DEVICES=$(lsscsi -t | grep -i "sata" | awk '{print $NF}')

while IFS= read -r dev; do
    if [[ ! -z "$dev" ]]; then
        type=$(hdparm -I $dev | grep -e "Nominal Media Rotation Rate:" | cut -d":" -f2 | tr ' ' '-')
        ELEMENTO_POWER_STORAGE=$(echo "$ELEMENTO_POWER_STORAGE + ${STORAGE_POWER_DRAW[$type]}" | bc)
    fi
done <<< "$STORAGE_DEVICES"

echo $ELEMENTO_POWER_STORAGE
