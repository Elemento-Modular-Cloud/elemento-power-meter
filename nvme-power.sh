#!/bin/bash

export ELEMENTO_POWER_NVME=0
NVME_DEVICES=$(nvme list | tail -n +3 | awk '{print $1}')

while IFS= read -r dev; do
    if [[ ! -z "$dev" ]]
    then
        power_states=( $(smartctl -a "$dev" | sed -n '/Supported Power States/,/^ *$/p' | head -n -1 | tail -n +3 | grep -Eo '[+-]?[0-9]+([.][0-9]+)?W') )
        power_state=$(nvme get-feature "$dev" -f 2 -H | tail -1 | grep -o [0-9])
        ELEMENTO_POWER_NVME=$(echo "$ELEMENTO_POWER_NVME + ${power_states[$power_state]}" | bc)
    fi
done <<< "$NVME_DEVICES"

echo $ELEMENTO_POWER_NVME
