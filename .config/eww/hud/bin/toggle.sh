#!/bin/bash
eww="eww -c $HOME/.config/eww/hud"
screen=$(hyprctl -j monitors|jq '.[]|select(.focused).id')
if ! $eww close hud
then 
    $eww open hud --screen $screen
    # $eww update apps="$(< $HOME/.config/eww/hud/apps.json)"
    if eval $($eww get show_notifs)
    then
        $eww open notifs --screen $screen
    fi

else
    $eww close notifs
    $eww close tray
fi
