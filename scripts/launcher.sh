#!/usr/bin/env bash

# Matrix-themed rofi launcher (toggle behavior)
MATRIX_THEME="$HOME/.config/rofi/matrix-launcher.rasi"

if pgrep -x "rofi" > /dev/null; then
    pkill -x rofi
else
    if [ -f "$MATRIX_THEME" ]; then
        exec rofi -show drun -theme "$MATRIX_THEME"
    else
        exec rofi -show drun -no-config
    fi
fi
