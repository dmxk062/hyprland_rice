#!/bin/bash
declare -A niceNames=(
[firefox]="󰈹 Firefox"
[mpv]="󱜅 MPV"
)
function playerquery(){
    playername=$(playerctl metadata --format "{{playerName}}")
    playerid="$playername"
    if [[ "$line" == "Playing" ]]
    then
        state=1
        icon=""
    elif [[ "$playername" == "" ]]
    then
        icon=""
        playername="No Player"
        state=0
    else
        icon="󰐎"
        state=0
    fi
    if [[ -v "niceNames[$playername]" ]]
    then 
        playername=${niceNames[$playername]}
    fi
    label="$playername $icon"
    printf '{"state":"%s","string":"%s","name":"%s"}\n' "$state" "$label" "$playerid"
}
playerquery
playerctl -F status|while read -r line
do
    playerquery
done
