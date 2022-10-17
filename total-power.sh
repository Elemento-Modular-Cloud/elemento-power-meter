#!/bin/bash

export ELEMENTO_POWER_TOTAL

cpu=$(bash ./cpu-rapl-power.sh)
ram=$(bash ./ram-power.sh)
nvme=$(bash ./nvme-power.sh)
storage=$(bash ./storage-power.sh)
ELEMENTO_POWER_TOTAL=$(echo "$cpu + $ram + $nvme + $storage" | bc)

echo "CPU draw [W]: $cpu"
echo "RAM draw [W]: $ram"
echo "NVMe draw [W]: $nvme"
echo "SATA/SAS draw [W]: $storage"
echo "System draw [W]: $ELEMENTO_POWER_TOTAL"
