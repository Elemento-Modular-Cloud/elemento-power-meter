#!/bin/bash

export ELEMENTO_POWER_NVME=0
NVME_DEVICES=$(nvme list | tail -n +3 | awk '{print $1}')

while IFS= read -r dev; do
    if [[ ! -z "$dev" ]]
    then
        power_states=( $(smartctl -a "$dev" | sed -n '/Supported Power States/,/^ *$/p' | head -n -1 | tail -n +3 | grep -Eo '[+-]?[0-9]+([.][0-9]+)?W') )
        power_state=$(nvme get-feature "$dev" -f 2 | grep -o "0x0000000[0-9]" | tail -c 2)
        ELEMENTO_POWER_NVME=$(echo "$ELEMENTO_POWER_NVME + ${power_states[$power_state - 1]}" | bc)
    fi
done <<< "$NVME_DEVICES"

echo $ELEMENTO_POWER_NVME
