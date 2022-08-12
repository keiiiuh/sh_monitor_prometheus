#!/bin/bash

SDA_MEM=$(df -h | grep sda | cut -d" " -f14 | sed 's/G//')
echo "#how_much_gb_free_on_dev_sda"
echo "memory_dev_sda_gb_fre $SDA_MEM"

RAM_MEM=$(free -h | grep Mem | cut -d" " -f47 | sed 's/Gi//')
echo "#how_much_gb_ram_memory_free"
echo "memory_ram_gb_free $RAM_MEM"

CPU_LOAD_PERECENTAGE=$(eval $(awk '/^cpu /{print "previdle=" $5 "; prevtotal=" $2+$3+$4+$5 }' /proc/stat); sleep 0.4; eval $(awk '/^cpu /{print "idle=" $5 "; total=" $2+$3+$4+$5 }' /proc/stat); intervaltotal=$((total-${prevtotal:-0})); echo "$((100*( (intervaltotal) - ($idle-${previdle:-0}) ) / (intervaltotal) ))")
echo "#how_much_current_cpu_is_load"
echo "cpu_current_load $CPU_LOAD_PERECENTAGE"

CPU_MAX_GHZ=$(cat /proc/cpuinfo | grep "model name" | cut -d" " -f8 | sed 's/GHz//')
echo "#cpu_max_ghz"
echo "cpu_max_ghz $CPU_MAX_GHZ"

CPU_CURRENT_LOAD_HZ=$(bc<<<"scale=2;$CPU_MAX_GHZ*1000 / 100 * $CPU_LOAD_PERECENTAGE")
echo "#current_cpu_load_hz"
echo "cpu_current_load_hz $CPU_CURRENT_LOAD_HZ"


TEMP_DEVICE_COUNT=$(ls /sys/class/thermal/ | grep "thermal_zone" | tail -n 1 | sed 's/thermal_zone//')
echo "#temp_dev"
if [[ "$TEMP_DEVICE_COUNT" != "" ]]; then


for num in `seq $TEMP_DEVICE_COUNT`;
        do
                DEVICE_TEMP=$(cat /sys/class/thermal/thermal_zone$num/temp)
                echo "temp_on_$num_device $DEVICE_TEMP"
done

else
echo "temp_on_0_device 0"


fi


SYSTEM_UPTIME=$(cat /proc/uptime | cut -d" " -f1)
SYSTEM_UPTIME_HOURS=$(bc<<<"scale=2;$SYSTEM_UPTIME / 60 / 60")
echo "$SYSTEM_UPTIME"
echo "#system_uptime_in_hours"
echo "system_uptime_hours $SYSTEM_UPTIME_HOURS"
