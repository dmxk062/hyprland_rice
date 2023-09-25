#!/bin/bash

noconfirm=$2
function prompt(){
    question=$1
    action=$2
    if [[ $noconfirm == "true" ]]
    then
        bash -c "$action"
    else
        if zenity --question --text="$question"
        then
            bash -c "$action"
        else
            exit
        fi
    fi
}
case $1 in
    p)
        prompt "Shutdown System?" "systemctl poweroff"
        ;;
    r)
        prompt "Reboot System?" "systemctl reboot"
        ;;
    l)
        prompt "Lock Screen?" "gtklock -dS"
        ;;
    s)
        prompt "Suspend System?" "gtklock -dS&& sleep 1 &&systemctl suspend"
        ;;
    e)  
        prompt "Logout to TTY?" "hyprctl dispatch exit 1"
        ;;
    u)
        prompt "Reboot into Firmware Setup?" "systemctl reboot --firmware-setup"
esac
