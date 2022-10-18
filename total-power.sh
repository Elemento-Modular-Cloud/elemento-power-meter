#!/bin/bash

export ELEMENTO_POWER_TOTAL

cpu=$(bash ./cpu-rapl-power.sh)
ram=$(bash ./ram-power.sh)
nvme=$(bash ./nvme-power.sh)
storage=$(bash ./storage-power.sh)
ELEMENTO_POWER_TOTAL=$(echo "$cpu + $ram + $nvme + $storage" | bc)

echo "--------------------------------------"
printf "CPU draw [W]: %.3f\n" $cpu
printf "RAM draw [W]: %.3f" $ram
printf "NVMe draw [W]: %.3f" $nvme
printf "SATA/SAS draw [W]: %.3f" $storage
echo "--------------------------------------"
printf "System draw [W]:  %.3f" $ELEMENTO_POWER_TOTAL
echo "--------------------------------------"
