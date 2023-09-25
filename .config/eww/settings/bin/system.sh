#!/bin/bash
eww="eww -c $HOME/.config/eww/settings"



function edge(){
    if eww -c "$HOME/.config/eww/hud" close edge
    then
        $eww update edge=false
    else
        eww -c "$HOME/.config/eww/hud" open edge
        $eww update edge=true
    fi
}
function idle(){
    if killall swayidle 
    then
        $eww update idle=false
    else
        swayidle -w & disown
        $eww update idle=true
    fi
}
function clock(){
    if killall gnome-clocks
    then
        $eww update clocks=false
    else
        gnome-clocks --gapplication-service & disown
        $eww update clocks=true
    fi
}


case $1 in
    edge)
        edge;;
    idle)
        idle;;
    clock)
        clock;;
esac
