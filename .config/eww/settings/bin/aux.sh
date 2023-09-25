#!/bin/bash
function update(){
    eww -c $HOME/.config/eww/settings update "$@" # send whatever to eww
    eww -c $HOME/.config/eww/top-bar/ update "$@" # send whatever to eww
}
function get_mute_icon_out(){ 
    if eval $(pamixer --get-mute)
    then
        update mute_out_icon="󰟎"
    else
        update mute_out_icon="󰋋"
    fi
}
function get_mute_icon_in(){
    if eval $(pamixer --get-mute --default-source)
    then
        update mute_in_icon=""
    else
        update mute_in_icon=""
    fi
}
function get_mute_out(){
    update mute_out="$(pamixer --get-mute)"
    get_mute_icon_out
}
function toggle_mute_out(){
    pamixer -t
    get_mute_out
}
function get_mute_in(){
    update mute_in="$(pamixer --get-mute --default-source)"
    get_mute_icon_in
}
function toggle_mute_in(){
    pamixer -t --default-source
    get_mute_in
}
function get_volume_out(){
    update volume_out=$(pamixer --get-volume)
}
function get_volume_in(){
    update volume_in=$(pamixer --get-volume --default-source)
}
function set_volume_out(){
    pamixer --set-volume $1
    get_volume_out
}
function set_volume_in(){
    pamixer --default-source --set-volume $1
    get_volume_in
}
function get_all_out(){
    get_volume_out
    get_mute_icon_out
    get_mute_out
}
function get_all_in(){
    get_volume_in
    get_mute_icon_in
    get_mute_in
}
case $1 in
    get-mute)
        get_mute_${2};;
    toggle-mute)
        toggle_mute_${2};;
    get-volume)
        get_volume_${2};;
    set-volume)
        set_volume_${2} $3;;
    get-all)
        get_all_${2};;
esac
