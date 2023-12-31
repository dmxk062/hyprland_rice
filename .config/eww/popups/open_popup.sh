#!/bin/bash

eww="eww -c $HOME/.config/eww/popups"

case $1 in 
    in)
        oldid=$(pgrep "open_popup" |head -n 1)
        if [[ $oldid == $BASHPID ]]
        then
            $eww open in_popup --screen 0
            sleep 2
            $eww close in_popup
        fi
        ;;
    out)
        oldid=$(pgrep "open_popup" |head -n 1)
        if [[ $oldid == $BASHPID ]]
        then
            $eww open out_popup --screen 0
            sleep 2
            $eww close out_popup
        fi
        ;;
    bright)
        $eww open bright_popup --screen 0
        sleep 1
        $eww close bright_popup
esac
