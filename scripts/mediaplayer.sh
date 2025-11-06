#!/bin/bash

player_status=$(playerctl status 2> /dev/null)

if [ "$player_status" = "Playing" ] || [ "$player_status" = "Paused" ]; then
    artist=$(playerctl metadata artist 2> /dev/null)
    title=$(playerctl metadata title 2> /dev/null)
    
    if [ -z "$artist" ]; then
        text="$title"
    else
        text="$artist - $title"
    fi
    
    # Return JSON for Waybar
    echo "{\"text\":\"$text\", \"tooltip\":\"$text\", \"class\":\"$player_status\"}"
else
    echo "{\"text\":\"\", \"tooltip\":\"No media playing\", \"class\":\"Stopped\"}"
fi
