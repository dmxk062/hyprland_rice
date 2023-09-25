#!/bin/bash
killall eww
killall wifi.sh
killall mpris.sh
killall ws.sh
killall notif.sh
killall hyprmon.sh
eww -c $HOME/.config/eww/top-bar daemon & disown
eww -c $HOME/.config/eww/top-bar open bar & disown
eww -c ~/.config/eww/popups daemon & disown
eww -c ~/.config/eww/settings daemon & disown
eww -c ~/.config/eww/hud daemon & disown
eww -c ~/.config/eww/hud open edge & disown
eww -c ~/.config/eww/hud update apps="$(< $HOME/.config/eww/hud/apps.json)"
~/.config/eww/settings/bin/notif.sh monitor & disown
sleep 2
# makoctl mode -s eww_override
~/.config/eww/settings/bin/audio_state.sh
~/.config/eww/settings/bin/sinks_sources.sh upd sinks & disown
~/.config/eww/settings/bin/sinks_sources.sh upd sources & disown
~/.config/eww/top-bar/bin/hyprmon.sh monitor & disown
# ~/.config/eww/panel/bin/notif.sh monitor & disown
