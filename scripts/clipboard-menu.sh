#!/bin/bash

CLIPBOARD_FILE="$HOME/clipboard.txt"

# Check if file exists and has content
if [ ! -f "$CLIPBOARD_FILE" ] || [ ! -s "$CLIPBOARD_FILE" ]; then
    notify-send "Clipboard" "No clipboard history yet"
    exit 0
fi

# Show clipboard history in a terminal
kitty --title "Clipboard History" -e less "$CLIPBOARD_FILE"
