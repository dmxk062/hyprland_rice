#!/usr/bin/env bash

screen=$(hyprctl -j monitors|jq '.[]|select(.focused).id')
eww -c $XDG_CONFIG_HOME/eww/settings open settings --screen $screen

