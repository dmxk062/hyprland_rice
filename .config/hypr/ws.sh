#!/bin/bash

workspace_order='{
"20web":1,
"21web2":2,
"22web3":3,
"23web4":4,
"0":10,
"1":11,
"2":12,
"3":13,
"4":14,
"5":15,
"6":16,
"7":17,
"8":18,
"9":19,
"10":20,
"11":21,
"12":22,
"13":23,
"14":24,
"15":25,
"16":26,
"19games":300,
"special:1":400
}'
workspaces='[
{"name":"20web","pos":1},
{"name":"21web2","pos":2},
{"name":"22web3","pos":3},
{"name":"23web4","pos":4},
{"name":"0","pos":10},
{"name":"1","pos":11},
{"name":"2","pos":12},
{"name":"3","pos":13},
{"name":"4","pos":14},
{"name":"5","pos":15},
{"name":"6","pos":16},
{"name":"7","pos":17},
{"name":"8","pos":18},
{"name":"9","pos":19},
{"name":"10","pos":20},
{"name":"11","pos":21},
{"name":"12","pos":22},
{"name":"13","pos":23},
{"name":"14","pos":24},
{"name":"15","pos":25},
{"name":"16","pos":26},
{"name":"19games","pos":800}
]'



function get_active_workspace_name(){
    hyprctl activeworkspace -j|jq  '.name'
}
function get_ws_list(){
        active=$(get_active_workspace_name)
        hyprctl workspaces -j|jq --argjson order "$workspace_order"  --argjson activename "$active" 'map({
            id:.id,
            name:.name,
            display:.monitor,
            count:.windows,
            pos:$order[.name],
            special:(if .name | test("special:.*") then true else false end),
            active:(if .name == $activename then true else false end)
        })'|jq 'map(select(.special == false))'|jq -Mc 'sort_by(.pos)'

}

function increment(){
    list="$(get_ws_list)"
    next="$(echo "$list"|jq -Mcr '. as $data | (map(.active) | index(true)) as $index | $data[$index + 1].name')"
    if [[ "$next" == "null" ]]
    then 
        active=$(get_active_workspace_name)
        workspace_list="$(echo "$workspaces"|jq -Mc --argjson activename "$active" 'map(. + {active: (if .name == $activename then true else false end)})')"
        next="$(echo "$workspace_list"|jq -Mcr '. as $data | (map(.active) | index(true)) as $index | $data[$index + 1].name')"
    fi
    hyprctl dispatch workspace name:$next
}
function decrement(){
    list="$(get_ws_list)"
    prev="$(echo "$list"|jq -Mcr '. as $data | (map(.active) | index(true)) as $index | $data[$index -1].name')"
    if [[ "$prev" == "null" ]]
    then 
        active=$(get_active_workspace_name)
        workspace_list="$(echo "$workspaces"|jq -Mc --argjson activename "$active" 'map(. + {active: (if .name == $activename then true else false end)})')"
        prev="$(echo "$workspace_list"|jq -Mcr '. as $data | (map(.active) | index(true)) as $index | $data[$index -1].name')"
    fi
    hyprctl dispatch workspace name:$prev
}
case $1 in
    inc)
        increment;;
    dec)
        decrement;;
esac
