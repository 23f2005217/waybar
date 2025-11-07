#!/bin/bash

# Matrix-themed power menu options
option1="⏻  Shutdown"
option2="  Reboot"
option3="  Suspend"
option4="  Logout"

# Rofi command with matrix theme
selected=$(printf "%s\n%s\n%s\n%s\n" "$option1" "$option2" "$option3" "$option4" | \
    rofi -dmenu \
    -theme ~/.config/rofi/matrix-power.rasi \
    -mesg ">>> SYSTEM POWER CONTROL <<<" \
    -p ">" \
    -i)

case $selected in
  "$option1")
    systemctl poweroff -i;;
  "$option2")
    systemctl reboot;;
  "$option3")
    systemctl suspend;;
  "$option4")
    hyprctl dispatch exit;;
esac
