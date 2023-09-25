#!/bin/bash
eww="eww -c $HOME/.config/eww/hud"

if ! $eww close notifs
then 
    $eww open notifs --screen $(hyprctl -j monitors|jq '.[]|select(.focused).id')& disown
    $eww update show_notifs=true
else
    $eww update show_notifs=false
fi

