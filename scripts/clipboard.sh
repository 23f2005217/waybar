#!/bin/bash

# File to store clipboard history
CLIPBOARD_FILE="$HOME/clipboard.txt"

# Create the file if it doesn't exist
touch "$CLIPBOARD_FILE"

# Get current clipboard content
current_clip=$(wl-paste 2>/dev/null)

# If clipboard has content
if [ -n "$current_clip" ]; then
    # Get the first 45 characters for display
    display_text=$(echo "$current_clip" | head -c 45 | tr '\n' ' ')
    
    # Add ellipsis if text is longer
    if [ ${#current_clip} -gt 45 ]; then
        display_text="${display_text}..."
    fi
    
    # Check if this content is already the last entry in history
    last_entry=$(tail -n 1 "$CLIPBOARD_FILE" 2>/dev/null)
    
    # Only add to history if it's different from the last entry
    if [ "$current_clip" != "$last_entry" ]; then
        # Append to clipboard file with timestamp
        echo "--- $(date '+%Y-%m-%d %H:%M:%S') ---" >> "$CLIPBOARD_FILE"
        echo "$current_clip" >> "$CLIPBOARD_FILE"
        echo "" >> "$CLIPBOARD_FILE"
    fi
    
    # Return JSON for Waybar
    echo "{\"text\":\"$display_text\", \"tooltip\":\"$current_clip\", \"class\":\"active\"}"
else
    echo "{\"text\":\"Empty\", \"tooltip\":\"No clipboard content\", \"class\":\"empty\"}"
fi
