#!/bin/bash
declare -A niceNames=(
[firefox]="󰈹 Firefox"
[mpv]="󱜅 MPV"
)
function image(){
    img_file=$(playerctl metadata 'mpris:artUrl'|python -c "import urllib.parse, sys; print(urllib.parse.unquote(sys.stdin.read().strip()))"|sed 's/file:\/\///')
    # god this is hacky. playerctl returns filenames as URIs with ASCII encoded unicode and spaces. so i pipe it through python
    if [[ "$img_file" == "" ]]
    then
        img=false
        img_file="null"
    else
        img=true
    fi
    if ! [[ -f "$img_file" ]]
    then
        img_file="null"
    fi
}
function title(){
    title=$(playerctl metadata 'xesam:title'|sed 's/"/\\"/g')
    artist=$(playerctl metadata 'xesam:artist'|sed 's/"/\\"/g')
    if [[ "$title" == "" ]]
    then 
        title="No Players Found"
        artist=" "
    fi
}
function metadata(){
    image
    title
    printf '{"img":%s,"image":"%s","title":"%s","artist":"%s"}' "$img" "$img_file" "$title" "$artist"
}
function playerquery(){
    playername=$(playerctl metadata --format "{{playerName}}")
    playerid="$playername"
    if [[ "$line" == "Playing" ]]
    then
        playing=true
        icon=""
        active=true
    elif [[ "$playername" == "" ]]
    then
        icon=""
        playername="No Player"
        playing=false
        active=false
    else
        icon="󰐎"
        playing=false
        active=true
    fi
    if [[ -v "niceNames[$playername]" ]]
    then 
        playername=${niceNames[$playername]}
    fi
    printf '{"playing":%s,"icon":"%s","name":"%s","active":%s}\n' "$playing" "$icon" "$playerid" "$active"
}
function pos(){
    length=$(playerctl metadata --format "{{mpris:length/1000000}}")
    if [[ $length == "" ]]
    then
        length=0
    fi
    pos=$(echo "scale=0; $(playerctl metadata --format "{{position}}")/1000000"|bc)
    if ((pos == 0))
    then 
        position=false
    else
        position=true
    fi
    progress=$(echo "scale=4;($pos/$length)*100"|bc)
    printf '{"position":%s,"pos":%s,"length":%s,"progress":"%s"}\n' "$position" "$pos" "$length" "$progress"
}
function jump(){
   pos
   newpos=$1
   newpos=$(echo "$newpos*$length/100"|bc)
   playerctl position $newpos
}
function monitor(){
    playerquery
    playerctl -F status|while read -r line
    do
        playerquery
    done
}
case $1 in
    metadata)
        metadata;;
    pos)
        pos
        ;;
    monitor)
        monitor
        ;;
    jump)
        jump $2
        ;;

esac
