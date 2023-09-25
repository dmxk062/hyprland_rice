#!/bin/bash
#

urgency_names='
[
"low",
"normal",
"urgent"
]
'
notifs='[]'


function update(){
    eww -c $HOME/.config/eww/panel/ update "$@"
}
function update_panel(){
    eww -c $HOME/.config/eww/top-bar/ update "$@"
}
function handle_event(){
    time=$(date +'%H:%M')
    notifs_new_all=$(makoctl list|jq -Mc --argjson names "$urgency_names" --arg time "$time" '.data|.[]|map({time:$time,id:.id.data,name:."app-name".data,icon:."app-icon".data,title:.summary.data,text:.body.data,type:.category.data,urgency:.urgency.data,level:$names[.urgency.data],"actions":(.actions.data|to_entries | map({"name":.value, "action":.key})),expanded: false})' |jq 'sort_by(.id)|reverse' -Mc)
    if [[ "$notifs_new_all" == "[]" ]]
    then 
        new_notif_array="[]"
    else
        new_notif_array=$(echo "$notifs $notifs_new_all"|jq -s 'flatten|unique_by(.id)'|jq  '. | to_entries | map(.value + { "index": .key | tonumber })' -Mc)
    fi
    notifs=$new_notif_array
    echo $notifs|tee /tmp/.notifs.json

}
function update_count(){
    makoctl list|jq '.data|.[]|length'
}

function monitor(){ 
    [[ -f /tmp/.notifs.json ]]&&touch /tmp/.notifs.json
    dbus-monitor "interface='org.freedesktop.Notifications'" |while read line
    do
        if echo "$line"|grep -q "signal"||echo "$line"|grep -q "member="
        then
            temp_notifs="$(handle_event)"
            temp_notifcount="$(update_count)"
            update notifs="$temp_notifs"
            update_panel notifs="$temp_notifs"
            update notif-count="$temp_notifcount"
            update_panel notif-count="$temp_notifcount"
        fi
    done
}

function reveal(){
    index=$1
    notifs=$(< /tmp/.notifs.json)
    notifs="$(echo $notifs| jq -Mc --argjson index $index 'map(if .index == $index then . + {"expanded": true} else . end)')"
    update notifs="$notifs"
}
function unreveal(){
    index=$1
    notifs=$(< /tmp/.notifs.json)
    notifs="$(echo $notifs| jq -Mc --argjson index $index 'map(if .index == $index then . + {"expanded": false} else . end)')"
    update notifs="$notifs"
}
case $1 in 
    monitor)
        monitor;;
    toggle-mode)
        if [[ "$(makoctl mode)" == "eww_override" ]]
        then
            makoctl mode -r eww_override
            update hide-notif-popups=false
            update_panel hide-notif-popups=false
        else
            makoctl mode -s eww_override
            update hide-notif-popups=true
            update_panel hide-notif-popups=true
        fi;;
    toggle-panel)
        if eww -c $HOME/.config/eww/panel/ close notifcenter
        then
            true
        else
            eww -c $HOME/.config/eww/panel/ open notifcenter
        fi
        ~/.config/eww/panel/bin/todo.sh upd
        ;;
    upd)
        paplay "/usr/share/sounds/freedesktop/stereo/bell.oga"
        update notifs="$(handle_event)"
        update notif-count="$(update_count)"
        ;;
    reveal)
        reveal $2
        ;;
    unreveal)
        unreveal $2
        ;;
esac
