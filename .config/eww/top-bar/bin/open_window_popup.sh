#!/bin/bash
eww="eww -c $HOME/.config/eww/top-bar"
if ! $eww close window_controls 
then
    $eww open window_controls
fi

