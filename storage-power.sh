#!/bin/bash

isActive() {
    device=$(echo "$1" | cut -d "/" -f3)
    cmd='cat /proc/diskstats | grep "$device" | xargs'
    stats0=$(eval $cmd)
    sleep .1s
    stats1=$(eval $cmd)
    DIFF=$(diff $stats0 $stats1)
    return [ "$DIFF" != "" ]
}

activityModifier() {
    if isActive $1; then
        return 1.
    fi
    return .2
}

declare -a STORAGE_POWER_DRAW
STORAGE_POWER_DRAW["SolidStateDevice"]=4.2
STORAGE_POWER_DRAW["15000"]=6.5
STORAGE_POWER_DRAW["10000"]=5.8
STORAGE_POWER_DRAW["7200"]=8

export ELEMENTO_POWER_STORAGE=0
STORAGE_DEVICES=$(lsscsi -t | grep -i "sata" | awk '{print $NF}')

while IFS= read -r dev; do
    if [[ ! -z "$dev" ]]; then
        type=$(hdparm -I $dev | grep -e "Nominal Media Rotation Rate:" | cut -d":" -f2 | tr -d ' ')
        state=$(hdparm -C $dev | grep -e "drive state is:" | cut -d ":" -f2 | tr -d ' ')
        modifier=1.
        case $state in
            "unknown")
                modifier=$(activityModifier $dev)
                ;;
            "active/idle")
                modifier=$(activityModifier $dev)
                ;;
            "standby")
                modifier=.2
                ;;
            "sleeping")
                modifier=.1
                ;;
        esac
        ELEMENTO_POWER_STORAGE=$(echo "$ELEMENTO_POWER_STORAGE + ${STORAGE_POWER_DRAW[$type]} * $modifier" | bc)
    fi
done <<< "$STORAGE_DEVICES"

echo $ELEMENTO_POWER_STORAGE
