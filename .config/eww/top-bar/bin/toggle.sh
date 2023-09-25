#!/bin/bash
EWW="eww -c $HOME/.config/eww/top-bar/"
var=$1
if [[ "$($EWW get $var)" == "true" ]]
then
    $EWW update "$var=false"
else
    $EWW update "$var=true"
fi
