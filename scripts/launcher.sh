#!/bin/bash

# Check if wofi is already running
if pgrep -x "wofi" > /dev/null; then
    # If wofi is running, kill it (toggle behavior)
    pkill -x wofi
else
    # If not running, start wofi
    wofi -c ~/.config/wofi/config -I
fi
