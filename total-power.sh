#!/bin/bash

export ELEMENTO_POWER_TOTAL

cpu=$(bash ./cpu-rapl-power.sh)
ram=$(bash ./ram-power.sh)
nvme=$(bash ./nvme-power.sh)
storage=$(bash ./storage-power.sh)
ELEMENTO_POWER_TOTAL=$(echo "$cpu + $ram + $nvme + $storage" | bc)

echo "--------------------------------------"
printf "CPU draw [W]: %.1f\n" $cpu
printf "RAM draw [W]: %.1f\n" $ram
printf "NVMe draw [W]: %.1f\n" $nvme
printf "SATA/SAS draw [W]: %.1f\n" $storage
echo "--------------------------------------"
printf "System draw [W]:  %.1f\n" $ELEMENTO_POWER_TOTAL
echo "--------------------------------------"
