#!/bin/bash

NICS=$(ls /sys/class/net | grep "en[op]*\|eth*")

echo $NICS

export ELEMENTO_POWER_NICS=0

while IFS= read -r nic; do

    echo $nic

    info=$(ethtool $nic)

    speed=$(echo "$info" | grep "Speed: " | cut -d ":" -f2 | tr -d ' ' | grep -Eo [0-9]+)
    transciever=$(echo "$info" | grep "Transceiver: " | cut -d ":" -f2 | tr -d ' ')
    port=$(echo "$info" | grep "Port: " | cut -d ":" -f2 | tr -d ' ')

    if [[ -z "$speed" ]]; then
        continue
    fi

    gbps_per_watt=0.
    if [[ $speed -eq 100 ]]; then
        gbps_per_watt=.1
    elif [[ $speed -eq 1000 ]]; then
        gbps_per_watt=.45
    elif [[ $speed -eq 10000 ]]; then
        gbps_per_watt=.8
    else
        gbps_per_watt=.9
    fi

    echo $gbps_per_watt

    medium_correction=1.
    if [[ $port -eq "TwistedPair" ]]; then
        medium_correction=1.
    elif [[ $port -eq "Direct Attach Copper" ]]; then
        medium_correction=3.5
    elif [[ $port -eq "FIBRE" ]]; then
        medium_correction=2.
    fi

    nic_power=`bc -l <<< "$speed / 1000 * $gbps_per_watt * $medium_correction"`
    ELEMENTO_POWER_NICS=`bc -l <<< "$ELEMENTO_POWER_NICS + $nic_power"`

done <<< "$NICS"

echo $ELEMENTO_POWER_NICS