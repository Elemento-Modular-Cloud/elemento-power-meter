#!/bin/bash

export ELEMENTO_POWER_TOTAL

cpu=$(bash ./cpu-rapl-power.sh)
ram=$(bash ./ram-power.sh)
nvme=$(bash ./nvme-power.sh)
storage=$(bash ./storage-power.sh)
ELEMENTO_POWER_TOTAL=$(echo "$cpu + $ram + $nvme + $storage" | bc)
efficiency=$(bash ./psu-efficiency.sh)
ELEMENTO_POWER_WALL=$(echo "$ELEMENTO_POWER_TOTAL" / "$efficiency" | bc)

echo "--------------------------------------"
printf "CPU draw [W]: %.1f\n" $cpu
printf "RAM draw [W]: %.1f\n" $ram
printf "NVMe draw [W]: %.1f\n" $nvme
printf "SATA/SAS draw [W]: %.1f\n" $storage
printf "PSU efficiency [\%]: %.1f\n" $efficiency
echo "--------------------------------------"
printf "System consumption [W]:  %.1f\n" $ELEMENTO_POWER_TOTAL
printf "System wall draw [W]:  %.1f\n" $ELEMENTO_POWER_WALL
echo "--------------------------------------"
