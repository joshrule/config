#!/bin/bash

while ! xprop -root | grep -q Free; do sleep 1; done
xrdb -merge ~/.Xresources
xsetroot -solid black
xbindkeys -f ~/.xbindkeysrc.scm
xrandr --output VGA-0 --auto --output LVDS --off
exec unclutter -idle 1 -root &
exec xterm &
#exec x-focus-manager &
#exec x-placement-manager &
#exec x-session
exec dwm
