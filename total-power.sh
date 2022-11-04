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
printf "CPU draw [W]: %.1f (ε=1\%)\n" $cpu
printf "RAM draw [W]: %.1f (ε=10\%)\n" $ram
printf "NVMe draw [W]: %.1f (ε=10\%)\n" $nvme
printf "SATA/SAS draw [W]: %.1f (ε=15\%)\n" $storage
printf "NIC draw [W]: %.1f (ε=15\%)\n" $nics
printf "PSU efficiency [%%]: %.3f (ε=2\%)\n" $efficiency
echo "--------------------------------------"
printf "System consumption [W]:  %.1f (ε=10\%)\n" $ELEMENTO_POWER_TOTAL
printf "System wall draw [W]:  %.1f (ε=12\%)\n" $ELEMENTO_POWER_WALL
echo "--------------------------------------"
