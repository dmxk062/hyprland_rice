#!/bin/bash
if ! which wvkbd 
then
    notify-send "No wvkbd binary found"
    exit
fi
lockfile=/tmp/.eww_dmx_kbd.lock
eww="eww -c $HOME/.config/eww/panel"
if /usr/bin/kill -34 $(pgrep wvkbd)
then
    if [[ $($eww get kbd) == "true" ]]
    then 
        $eww update kbd=false
    else
        $eww update kbd=true
    fi
else
    $HOME/.local/bin/wvkbd --fn "Torus" --landscape-layers full --hidden &
fi

