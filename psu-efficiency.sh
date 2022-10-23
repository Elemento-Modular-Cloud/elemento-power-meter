#!/bin/bash

LOAD=$1
MAX_LOAD=${2:-"1600"}

LOAD_PC=`bc -l <<< "$LOAD / $MAX_LOAD * 100"`
EFFICIENCY=${3:-"Gold"}

declare -A EFFCURVES
EFFCURVES[Base]="0, 0, 80"
EFFCURVES[Bronze]="-0.0354, 2.58, 44.571"
EFFCURVES[Silver]="-0.0367, 2.67, 46.286"
EFFCURVES[Gold]="-0.0376, 2.73, 47.429"
EFFCURVES[Platinum]="-0.0389, 2.79, 49.762"
EFFCURVES[Titanium]="-0.0405, 2.90, 52.190"

readarray -td, P <<<"${EFFCURVES[$EFFICIENCY]}"; declare -p P;

ELEMENTO_PSU_EFFICIENCY=$(echo "0.01 * (${P[0]} * $LOAD_PC * $LOAD_PC + ${P[1]} * $LOAD_PC + ${P[2]})" | bc)
echo $ELEMENTO_PSU_EFFICIENCY