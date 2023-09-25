#!/bin/bash
eww="eww -c $HOME/.config/eww/hud"

if ! $eww close system
then 
    $eww open system --screen $(hyprctl -j monitors|jq '.[]|select(.focused).id')& disown
    $eww update show_system=true
else
    $eww update show_system=false
fi
