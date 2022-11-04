#!/bin/bash

isActive() {
    device=$(echo "$1" | cut -d "/" -f3)
    cmd='cat /sys/block/$device/stat'
    stats0=$(eval $cmd)
    sleep .1s
    stats1=$(eval $cmd)
    case "$stats0" in
        $stats1 )
            return false;;
        *)
            return true;;
    esac
    return 0
}

activityModifier() {
    if [ $(isActive $1) ]; then
        echo 1.
        return 0
    fi
    echo 0.2
    return 0
}

declare -A STORAGE_POWER_DRAW
STORAGE_POWER_DRAW["SolidStateDevice"]=4.2
STORAGE_POWER_DRAW["15000rpm"]=6.5
STORAGE_POWER_DRAW["10000rpm"]=5.8
STORAGE_POWER_DRAW["7200rpm"]=8

export ELEMENTO_POWER_STORAGE=0
STORAGE_DEVICES=$(lsscsi -t | grep -i "sata" | awk '{print $NF}')

while IFS= read -r dev; do
    if [[ ! -z "$dev" ]]; then
        dev_name=$(echo $dev | cut -d "/" -f3)
        is_rotational=$(cat /sys/block/$dev_name/queue/rotational)
        if [ "$is_rotational" == 1 ]; then
            type=$(sg_vpd --page=bdc $dev | grep -e "Nominal rotation rate:" | cut -d ":" -f2 | tr -d ' ')
        else
            type="SolidStateDevice"
        fi
        if [ $(isActive $dev_name) ]; then
            state="ACTIVE or IDLE"
        else
            #state=$(smartctl -n standby -n sleep -n idle -i $dev | grep -o "ACTIVE or IDLE\|IDLE_A\|IDLE_B\|SLEEP")
            state="STANDBY"
        fi
        modifier=1.
        case $state in
            "ACTIVE or IDLE"|"IDLE_A"|"IDLE_B")
                modifier=$(activityModifier $dev)
                ;;
            "STANDBY")
                modifier=.2
                ;;
            "SLEEP")
                modifier=.1
                ;;
            *)
                modifier=1.
                ;;
        esac
        devicepower=$(echo "${STORAGE_POWER_DRAW[$type]} * $modifier" | bc)
        ELEMENTO_POWER_STORAGE=$(echo "$ELEMENTO_POWER_STORAGE + $devicepower" | bc)
    fi
done <<< "$STORAGE_DEVICES"

echo $ELEMENTO_POWER_STORAGE
