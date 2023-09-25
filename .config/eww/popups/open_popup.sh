#!/bin/bash

eww="eww -c $HOME/.config/eww/popups/"

case $1 in 
    in)
        oldid=$(pgrep "open_popup" |head -n 1)
        if [[ $oldid == $BASHPID ]]
        then
            $eww open in_popup --screen 0
            $eww update invol=$(pamixer --get-volume --default-source)
            $eww update inmute=$(pamixer --get-mute --default-source)
            sleep 2
            $eww close in_popup
        else
            $eww update invol=$(pamixer --get-volume --default-source)
            $eww update inmute=$(pamixer --get-mute --default-source)
        fi
        ;;
    out)
        oldid=$(pgrep "open_popup" |head -n 1)
        if [[ $oldid == $BASHPID ]]
        then
            $eww open out_popup --screen 0
            $eww update outvol=$(pamixer --get-volume )
            $eww update outmute=$(pamixer --get-mute )
            sleep 2
            $eww close out_popup
        else
            $eww update outvol=$(pamixer --get-volume )
            $eww update outmute=$(pamixer --get-mute )
        fi
        ;;
    mpris)
        $eww open mpris_popup --screen 0
        sleep 1
        $eww close mpris_popup
        ;;
    bright)
        $eww open bright_popup --screen 0
        sleep 1
        $eww close bright_popup
esac
