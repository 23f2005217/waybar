#!/usr/bin/env bash

# Rofi-based clipboard picker
# Reads $HOME/clipboard.txt (created by clipboard.sh), shows entries in rofi,
# and copies the selected item back to the Wayland clipboard using wl-copy.

CLIPBOARD_FILE="$HOME/clipboard.txt"

if [ ! -f "$CLIPBOARD_FILE" ] || [ ! -s "$CLIPBOARD_FILE" ]; then
    notify-send "Clipboard" "No clipboard history yet"
    exit 0
fi

# Build a list of entries. Records are separated by blank lines; remove timestamp lines
# and collapse multi-line entries into single-line previews.
entries=$(awk 'BEGIN{RS=""; FS="\n"} {
    s=""
    for(i=1;i<=NF;i++) if($i !~ /^---/) {
        gsub(/\n/, " ", $i)
        if(length($i)>0) s = (s? s " " : "") $i
    }
    # trim
    sub(/^ +/, "", s); sub(/ +$/, "", s)
    if(length(s)>0) print s
}' "$CLIPBOARD_FILE")

if [ -z "$entries" ]; then
    notify-send "Clipboard" "No clipboard entries"
    exit 0
fi

# Show entries in rofi dmenu. Use -no-config for speed and set lines based on count.
count=$(echo "$entries" | wc -l)
lines=$(( count < 10 ? count : 10 ))
chosen=$(echo "$entries" | rofi -dmenu -i -p "Clipboard" -lines "$lines" -no-config)

if [ -n "$chosen" ]; then
    # Copy chosen text to Wayland clipboard
    printf "%s" "$chosen" | wl-copy
    notify-send "Clipboard" "Copied to clipboard"
fi

exit 0
