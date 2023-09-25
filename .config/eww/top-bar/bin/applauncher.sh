#!/bin/bash
eww="eww -c $HOME/.config/eww/top-bar"
function update(){
    $eww update "$@"
}
if $eww close app_launcher
then
    update launcher_open=false
else
    apps=$(< "$HOME/.config/eww/top-bar/apps.json")
    update launcher_open=true
    $eww open app_launcher
    update apps="$apps"
fi

