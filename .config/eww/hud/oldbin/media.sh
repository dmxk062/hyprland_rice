#!/bin/bash


function update(){
    eww -c $HOME/.config/top-bar update "$@"
    eww -c $HOME/.config/panel update "$@"
}


function monitor(){
    playerctl -F metadata -f '{"name":"{{default(playerName,"")}}","status":"{{default(status,"")}}","img":"{{default(mpris:artUrl,"")}}","title":"{{default(xesam:title,"")}}","artist":"{{default(xesam:artist,"")}}","length":{{default(mpris:length,"0")}},"pos":{{default(position,"1")}}}'|while read -r line 
do
    name=$(playerctl metadata '{{default(playerName,"")}}') 
    echo $name
done
}
monitor
