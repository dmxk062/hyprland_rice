#!/bin/bash

dev="/sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:41/PNP0C09:00/PNP0C0A:00/power_supply/BAT0"
if ! [[ -e "$dev" ]]
then
printf '{"perc":0,"time":"0","level":"high","status":"No Battery","icon":"󰟧","wattage":"0W","battery":false}'
exit
fi
max=$(< $dev/energy_full)
percentage=$(< $dev/capacity)
status=$(< $dev/status)
wattage=$(< $dev/power_now)
current=$(< $dev/energy_now)
    if [[ "$status" == "Charging" ]]
    then
        hours=$(bc <<< "($max - $current)/$wattage")
        minutes=$(bc <<< "( 60 * $max - 60 * $current  ) / $wattage - $hours")
        minutes=$(echo "((60 * $max - 60 * $current)/$wattage) - $hours * 60 "|bc)
    else
        hours=$(echo "($current / $wattage)"|bc)
        minutes=$(echo "($current * 60 / $wattage ) -$hours * 60"|bc)
    fi

