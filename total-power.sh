#!/bin/bash

export ELEMENTO_POWER_TOTAL

cpu=$(bash ./cpu-rapl-power.sh)
ram=$(bash ./ram-power.sh)
nvme=$(bash ./nvme-power.sh)
ELEMENTO_POWER_TOTAL=$(echo "$cpu + $ram + $nvme" | bc)

echo "CPU draw [W]: $cpu"
echo "RAM draw [W]: $ram"
echo "NVMe draw [W]: $nvme"
echo "System draw [W]: $ELEMENTO_POWER_TOTAL"
