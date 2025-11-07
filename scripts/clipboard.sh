#!/bin/bash

latest_id=$(cliphist list | head -n1 | awk '{print $1}')
current_clip=$(cliphist decode "$latest_id" 2>/dev/null)

if [ -n "$current_clip" ]; then
    display_text=$(printf '%s' "$current_clip" | tr '\n' ' ' | head -c 45)
    if [ ${#current_clip} -gt 45 ]; then
        display_text="${display_text}..."
    fi

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
