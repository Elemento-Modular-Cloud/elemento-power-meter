#!/bin/bash

export ELEMENTO_POWER_TOTAL

PSU_MAX_LOAD=${1:-"850"}
PSU_EFF_RATING=${2:-"Platinum"}

cpu=$(bash ./cpu-rapl-power.sh)
ram=$(bash ./ram-power.sh)
nvme=$(bash ./nvme-power.sh)
storage=$(bash ./storage-power.sh)
nics=$(bash ./nic-power.sh)
ELEMENTO_POWER_TOTAL=$(echo "$cpu + $ram + $nvme + $storage + $nics" | bc)
efficiency=$(bash ./psu-efficiency.sh $ELEMENTO_POWER_TOTAL $PSU_MAX_LOAD $PSU_EFF_RATING)
ELEMENTO_POWER_WALL=$(echo "$ELEMENTO_POWER_TOTAL" / "$efficiency" | bc)

echo "--------------------------------------"
printf "CPU draw [W]: %.1f\n" $cpu
printf "RAM draw [W]: %.1f\n" $ram
printf "NVMe draw [W]: %.1f\n" $nvme
printf "SATA/SAS draw [W]: %.1f\n" $storage
printf "NIC draw [W]: %.1f\n" $nics
printf "PSU efficiency [%%]: %.3f\n" $efficiency
echo "--------------------------------------"
printf "System consumption [W]:  %.1f\n" $ELEMENTO_POWER_TOTAL
printf "System wall draw [W]:  %.1f\n" $ELEMENTO_POWER_WALL
echo "--------------------------------------"
