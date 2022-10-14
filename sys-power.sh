#! /bin/bash

cmd="cat /sys/devices/virtual/powercap/intel-rapl/intel-rapl:0/energy_uj"

export ELEMENTO_POWER_CPU

while :
do
  prevjoules=$(eval $cmd)
  sleep .5s
  joules=$(eval $cmd)
  ELEMENTO_POWER_CPU=$(echo "($joules - $prevjoules) / .5" | bc)
  echo $ELEMENTO_POWER_CPU
  prevjoules=$joules
done
