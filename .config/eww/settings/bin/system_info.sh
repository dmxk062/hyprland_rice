#!/bin/bash

eww="eww -c $HOME/.config/eww/settings"

distro=$(awk -F= '$1 == "ID"{print $2}' /etc/os-release|tr -d '"')
distro_name=$(awk -F= '$1 == "PRETTY_NAME"{print $2}' /etc/os-release|tr -d '"')
architecture=$(uname -m)
kernel_name=$(uname -s)
kernel_ver=$(uname -r)
processor_vendor="$(< /proc/cpuinfo awk -F: '/^vendor_id[[:space:]]+/ {print $2;exit}')"
processor_model="$(< /proc/cpuinfo awk -F: '/^model name[[:space:]]+/ {print $2;exit}')"
mem_total=$(awk '/MemTotal/ {print $2}' /proc/meminfo|numfmt --to=iec --from-unit=1024)
windowing_system=$XDG_SESSION_TYPE
window_manager=$XDG_CURRENT_DESKTOP
logo_path="/usr/share/icons/Tela/scalable/apps/distributor-logo-"
uptime="$(awk '{print int($1)}' /proc/uptime)"
current_time=$(date +%s)
get_logo(){
case $1 in
    arch)
        logo="${logo_path}archlinux.svg";;
    *)
        logo="${logo_path}${distro}.svg"
esac
if [[ -f "$logo" ]]
then
    true
else
    like=$(awk -F= '$1 == "ID_LIKE"{print $2}' /etc/os-release|tr -d '"')
    echo "No icon found for $1. using icon for $like"
    get_logo $like
fi
}
get_logo $distro
case $windowing_system in
    wayland)
        windowing_system_logo="/usr/share/icons/Tela/scalable/apps/wayland.svg";;
    x11)
        windowing_system_logo="/usr/share/icons/Tela/scalable/apps/xorg.svg";;
esac
formatted=$(printf '{"distro":"%s","arch":"%s","cpu_vendor":"%s","cpu_model":"%s","kernel":"%s","kernel_ver":"%s","ram":"%s","windowing_system":"%s","desktop":"%s", "logo":{"distro":"%s", "windowing_system":"%s"}, "uptime":"%s", "current_time":%s}' "$distro_name" "$architecture" \
    "$processor_vendor" "$processor_model" "$kernel_name" "$kernel_ver" "$mem_total" "$windowing_system" "$window_manager" "$logo" "$windowing_system_logo" "$uptime" "$current_time")  

$eww update system="$formatted"
