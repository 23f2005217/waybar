#!/bin/bash

entries="⏻  Shutdown\n  Reboot\n  Suspend\n  Logout"

selected=$(echo -e $entries | wofi --show dmenu --conf=$HOME/.config/wofi/config.power --style=$HOME/.config/wofi/style.widgets.css)

case $selected in
  *Shutdown)
    systemctl poweroff -i;;
  *Reboot)
    systemctl reboot;;
  *Suspend)
    systemctl suspend;;
  *Logout)
    hyprctl dispatch exit;;
esac
