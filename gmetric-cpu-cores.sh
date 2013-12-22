#!/bin/bash

# Script to pull individual stats per core into ganglia.
# The data is retrieved using mpstat each column represents a metric
########################################################################################
# TIME AM/PM  CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest   %idle
#  1     2     3      4       5        6     7         8      9      10      11       12
#########################################################################################

# Metric
USR="4"
SYS="6"

GMETRIC=`which gmetric`

# How manu cores do we have?
CORE=`grep "^processor" /proc/cpuinfo | wc -l`

# Get metrics
USR_CPU() {
mpstat -P ALL | awk 'NR > 4' | awk '{ if (NR=='$i') print $'$USR' }'
}

SYS_CPU() {
mpstat -P ALL | awk 'NR > 4' | awk '{ if (NR=='$i') print $'$SYS' }'
}


for ((i=1; i<=$CORE; i++)); do
	
	$GMETRIC -n "cpu_core_"$i"_sys%" -v `SYS_CPU` -t float -u "sys %" -g "cpu_metrics_per_core"

	$GMETRIC -n "cpu_core_"$i"_usr%" -v `USR_CPU` -t float -u "usr %" -g "cpu_metrics_per_core"
done







