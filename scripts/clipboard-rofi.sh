#!/usr/bin/env bash

MATRIX_THEME="$HOME/.config/rofi/matrix-clipboard.rasi"

entries=$(cliphist list | awk '{sub(/^[0-9]+ /,""); print}')

if [ -z "$entries" ]; then
    notify-send "Clipboard" "No clipboard entries"
    exit 0
fi

count=$(echo "$entries" | wc -l)
lines=$(( count < 12 ? count : 12 ))

if [ -f "$MATRIX_THEME" ]; then
    chosen=$(echo "$entries" | rofi -dmenu -i -p "Clipboard" -theme "$MATRIX_THEME")
else
    chosen=$(echo "$entries" | rofi -dmenu -i -p "Clipboard" -lines "$lines")
fi

if [ -n "$chosen" ]; then
    id=$(cliphist list | grep -n "$chosen" | head -n1 | cut -d: -f1)
    cliphist decode $id | wl-copy
    notify-send "Clipboard" "Copied to clipboard"
fi

exit 0
