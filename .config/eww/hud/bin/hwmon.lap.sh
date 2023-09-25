#!/bin/bash
function update(){
    eww -c $HOME/.config/eww/top-bar update "$@"

}
function nice(){
    numfmt --to=iec $@ 
}
function battery(){
    icons=("󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹")
    icons_charging=("󰢜" "󰢜" "󰂇" "󰂈" "󰢝" "󰂉" "󰢞" "󰂊" "󰂋" "󰂅")
    icon_warn="󰂃"
    BATDEV="/sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:41/PNP0C09:00/PNP0C0A:00/power_supply/BAT0"
    max=$(< $BATDEV/energy_full)
    percentage=$(< $BATDEV/capacity)
    status=$(< $BATDEV/status)
    wattage=$(< $BATDEV/power_now)
    current=$(< $BATDEV/energy_now)
    if [[ "$status" == "Charging" ]]
    then
        hours=$(echo "($max - $current)/$wattage"|bc)
        minutes=$(echo "((60 * $max - 60 * $current)/$wattage) - $hours * 60"|bc)
    else
        hours=$(echo "($current / $wattage)"|bc)
        minutes=$(echo "($current * 60 / $wattage ) -$hours * 60"|bc)
    fi
    time="${hours}h ${minutes}m"
    if [[ $percentage -gt 70 ]]
    then
        level="high"
    elif [[ $percentage -gt 40 ]]
    then
        level="medium"
    elif [[ $percentage -gt 5 ]]
    then
        level="low"
    else
        level="warn"
    fi
    if [[ $level == "warn" ]]
    then
        icon=$icon_warn
    elif [[ $status == "Charging" ]]
    then
        index=${percentage:0:1}
        index=$((index -1))
        icon=${icons_charging[$index]}
    else
        index=${percentage:0:1}
        index=$((index -1))
        icon=${icons[$index]}
    fi
    printf '{"perc":%s,"time":"%s","level":"%s","status":"%s","icon":"%s","wattage":%s}' "$percentage" "$time" "$level" "$status" "$icon" "$(echo "scale=1;$wattage / 1000000"|bc)"
}
function gpu(){
    GPUDEV="/sys/class/drm/card0/device"
    GPUTEMP="$GPUDEV/hwmon/hwmon*/"
    mem_used=$(< $GPUDEV/mem_info_vram_used)
    mem_total=$(< $GPUDEV/mem_info_vram_total)
    mem_free=$((mem_total - mem_used))
    mem_used_nice=$(nice $mem_used)
    mem_total_nice=$(nice $mem_total)
    mem_free_nice=$(nice $mem_free --round=down)
    mem_perc=$(echo "scale=4;($mem_used / $mem_total)*100"|bc )
    temp=$(< $GPUTEMP/temp1_input)
    usage=$(< $GPUDEV/gpu_busy_percent)
    temp=${temp::-3}
    printf '{"used":%s,"total":%s,"free":%s,"used_nice":"%s","total_nice":"%s","free_nice":"%s","perc":"%s","temp":%s, "usage":%s}\n' "$mem_used" "$mem_total" "$mem_free" "$mem_used_nice" "$mem_total_nice" "$mem_free_nice" "$mem_perc" "$temp" "$usage"
}
function cpu(){
    # CPUTEMP="/sys/devices/platform/asus-ec-sensors/hwmon/*/temp2_input"
    CPUTEMP="/sys/devices/pci0000:00/0000:00:18.3/hwmon/hwmon*/temp1_input"
    usage=$(mpstat 1 4 | awk 'END{print 100-$NF}')
    temp=$(< $CPUTEMP)
    temp=${temp::-3}
    if [[ $temp -gt 40 ]]
    then
        state="medium"
    elif [[ $temp -gt 50 ]]
    then
        state="high"
    elif [[ $temp -gt 65 ]]
    then 
        state="critical"
    else 
        state="low"
    fi
    printf '{"usage":%s,"temp":%s,"level":"%s"}\n' "$usage" "$temp" "$state"
}
function mem(){
    mem=$(< /proc/meminfo)
    mem_total=$(echo "$mem"|grep "MemTotal"|awk '{print $2}')
    mem_free=$(echo "$mem"|grep "MemFree"|awk '{print $2}')
    mem_avail=$(echo "$mem"|grep "MemAvailable"|awk '{print $2}')
    mem_used=$((mem_total - mem_avail))
    mem_perc=$(echo "scale=2;($mem_used/$mem_total)*100.0"|bc)
    swap_total=$(echo "$mem"|grep "SwapTotal"|awk '{print $2}')
    swap_free=$(echo "$mem"|grep "SwapFree"|awk '{print $2}')
    swap_used=$((swap_total - swap_free))
    swap_perc=$(echo "scale=2;($swap_used/$swap_total)*100.0"|bc)
    mem_total_nice=$(nice $((mem_total*1024)))
    mem_free_nice=$(nice $((mem_free*1024)))
    mem_avail_nice=$(nice $((mem_avail*1024)))
    mem_used_nice=$(nice $((mem_used*1024)))
    swap_total_nice=$(nice $((swap_total*1024)))
    swap_used_nice=$(nice $((swap_used*1024)))
    swap_free_nice=$(nice $((swap_free*1024)))
    printf '
{
"mem":{
"raw":{"total":%s,"free":%s,"avail":%s,"used":%s,"perc":"%s"},
"nice":{"total":"%s","free":"%s","avail":"%s","used":"%s"}
},
"swap":{
"raw":{"total":%s,"free":%s,"used":%s,"perc":"%s"},
"nice":{"total":"%s","free":"%s","used":"%s"}
}
}\n' $mem_total $mem_free $mem_avail $mem_used $mem_perc\
    $mem_total_nice $mem_free_nice $mem_avail_nice $mem_used_nice\
    $swap_total $swap_free $swap_used $swap_perc\
    $swap_total_nice $swap_free_nice $swap_used_nice
}
case $1 in
    mem)
        mem;;
    bat)
        battery
        update battery="$(battery)"
        ;;
    gpu)
        gpu;;
    cpu)
        cpu;;
    all)
        cpu 
        gpu
        mem
        battery;;
esac
