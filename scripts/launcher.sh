#!/usr/bin/env bash

# Fast rofi launcher (toggle behavior)
# - If rofi is already running, kill it (toggle)
# - Otherwise exec rofi in drun mode. Using -no-config reduces startup time.

if pgrep -x "rofi" > /dev/null; then
    pkill -x rofi
else
    exec rofi -show drun -no-config
fi
