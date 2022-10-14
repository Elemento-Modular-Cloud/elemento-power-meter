#!/bin/bash

declare -a RAM_POWER_DRAW
RAM_POWER_DRAW["DDR1"]=5.5
RAM_POWER_DRAW["DDR2"]=4.5
RAM_POWER_DRAW["DDR3"]=3
RAM_POWER_DRAW["DDR4"]=3

DMI_RAM=$(strace -f -e open dmidecode -t 17 2> /dev/null)
N_STICKS=$(echo $DMI_RAM | grep DDR* | wc -l)
RAM_TYPE=$(echo $DMI_RAM | grep -o DDR[1-4] | tail -1)

export ELEMENTO_POWER_RAM
ELEMENTO_POWER_RAM=(echo "$N_STICKS * $RAM_POWER_DRAW[$RAM_TYPE]" | bc)

echo $ELEMENTO_POWER_RAM

