#!/bin/bash

NVME_POWER_DRAW=(25 18 18 15 10 8 5)

export ELEMENTO_POWER_NVME=0
NVME_DEVICES=$(nvme list | tail -n +3 | awk '{print $1}')

while IFS= read -r dev; do
    if [[ ! -z "$dev" ]]
    then
        power_state=$(nvme get-feature "$dev" -f 2 | grep -o "0x0000000[0-9]" | tail -c 2)
        ELEMENTO_POWER_NVME=$(echo "$ELEMENTO_POWER_NVME + ${NVME_POWER_DRAW[$power_state]}" | bc)
    fi
done <<< "$NVME_DEVICES"

echo $ELEMENTO_POWER_NVME
