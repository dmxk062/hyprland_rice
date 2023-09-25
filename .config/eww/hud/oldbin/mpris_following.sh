#!/bin/bash
#
playerctl -F metadata -f '{"title":"{{title}}","player":"{{playerName}}","status":"{{status}}","position":{{position}},"length":{{default(mpris:length,"null")}},"artist":"{{artist}}",'|while read line
do  
    img_file=$(playerctl metadata 'mpris:artUrl'|sed 's/file:\/\///')
    printf "$line"
    if [[ "$img_file" == "" ]]
    then
        printf '"image":null}'
    else
        printf '"image":"%s"}' "$img_file"
    fi
    printf "\n"
    exit 0
done
