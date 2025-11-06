#!/bin/bash

# File to store clipboard history
CLIPBOARD_FILE="$HOME/clipboard.txt"

# Create the file if it doesn't exist
touch "$CLIPBOARD_FILE"

# Get current clipboard content
current_clip=$(wl-paste 2>/dev/null)

# If clipboard has content
if [ -n "$current_clip" ]; then
    # Get the first 45 characters for display (collapse newlines)
    display_text=$(printf '%s' "$current_clip" | tr '\n' ' ' | head -c 45)
    
    # Add ellipsis if text is longer
    if [ ${#current_clip} -gt 45 ]; then
        display_text="${display_text}..."
    fi
    
    # Check last stored clipboard content (last non-empty content line)
    last_entry=$(awk 'BEGIN{RS="---";FS="\n"} NR>1{print $2}' "$CLIPBOARD_FILE" 2>/dev/null | tail -n1)

    # Only add to history if it's different from the last entry
    if [ "$current_clip" != "$last_entry" ]; then
        # Append to clipboard file with timestamp
        echo "--- $(date '+%Y-%m-%d %H:%M:%S') ---" >> "$CLIPBOARD_FILE"
        echo "$current_clip" >> "$CLIPBOARD_FILE"
        echo "" >> "$CLIPBOARD_FILE"
    fi

    # Export variables and let python produce valid JSON (handles escaping)
    export DISPLAY_TEXT="$display_text"
    export TOOLTIP_TEXT="$current_clip"
    python3 - <<'PY'
import os, json, sys
out = {
    "text": os.environ.get("DISPLAY_TEXT", ""),
    "tooltip": os.environ.get("TOOLTIP_TEXT", ""),
    "class": "active"
}
sys.stdout.write(json.dumps(out))
PY
else
    python3 - <<'PY'
import json,sys
sys.stdout.write(json.dumps({"text":"Empty","tooltip":"No clipboard content","class":"empty"}))
PY
fi
