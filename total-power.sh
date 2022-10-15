#!/bin/bash

export ELEMENTO_POWER_TOTAL

cpu=$(bash ./cpu-power.sh)
ram=$(bash ./ram-power.sh)
nvme=$(bash ./nvme-power.sh)
ELEMENTO_POWER_TOTAL=$(echo "$cpu + $ram + $nvme" | bc)

echo $ELEMENTO_POWER_TOTAL
