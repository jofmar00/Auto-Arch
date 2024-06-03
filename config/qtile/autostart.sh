#!/bin/sh

#Background
feh --bg-fill /home/${USER}/wallpapers/wallpaper2.png
#Transparency
picom --no-vsync &
#Network manager
nm-applet &
