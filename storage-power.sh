#!/bin/bash

NVME_POWER_DRAW=(25 18 18 15 10 8 5)

export ELEMENTO_POWER_NVME
NVME_DEVICES=$(nvme list | tail -n +3 | awk '{print $1}')

echo $NVME_DEVICES

while IFS= read -r dev; do
    echo $(nvme get-feature "$dev" -f 2 | grep -o "0x0000000[0-9]" | tail -c 2)
done <<< "$NVME_DEVICES"
