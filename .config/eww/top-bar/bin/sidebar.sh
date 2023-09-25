#!/bin/bash
function update(){
    eww -c $HOME/.config/eww/top-bar update "$@"
}
dir=$HOME/.config/eww/panel/bin
function get_vals(){
   $dir/bluetooth.sh update_dev &
   $dir/aux.sh get-all out & 
   $dir/aux.sh get-all in &
   $dir/sinksource.sh upd sink &
   $dir/sinksource.sh upd source &
}
if eww -c $HOME/.config/eww/panel/ close panel
then 
    side=false
    update sidebar=$side
else 
    side=true
    eww -c $HOME/.config/eww/panel/ open panel
    update sidebar=$side
    get_vals
fi
