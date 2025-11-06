#!/bin/bash

CLIPBOARD_FILE="$HOME/clipboard.txt"

# Check if file exists and has content
if [ ! -f "$CLIPBOARD_FILE" ] || [ ! -s "$CLIPBOARD_FILE" ]; then
    notify-send "Clipboard" "No clipboard history yet"
    exit 0
fi

# Show clipboard history in a terminal
kitty --title "Clipboard History" -e less "$CLIPBOARD_FILE"

TOFI_CFG1="$HOME/.config/tofi/small-config"
TOFI_CFG2="$HOME/.config/tofi/config"
CLIP_CMD="cliphist list"

# Prefer tofi if available, prefer small-config -> config -> no config
if command -v tofi >/dev/null 2>&1; then
	if [ -f "$TOFI_CFG1" ]; then
		exec bash -lc "$CLIP_CMD | tofi -c \"$TOFI_CFG1\" | cliphist decode | wl-copy"
	elif [ -f "$TOFI_CFG2" ]; then
		exec bash -lc "$CLIP_CMD | tofi -c \"$TOFI_CFG2\" | cliphist decode | wl-copy"
	else
		exec bash -lc "$CLIP_CMD | tofi | cliphist decode | wl-copy"
	fi
fi

# Fallbacks: rofi, dmenu, fzf
if command -v rofi >/dev/null 2>&1; then
	exec bash -lc "$CLIP_CMD | rofi -dmenu -i -p 'Clipboard' | cliphist decode | wl-copy"
fi

if command -v dmenu >/dev/null 2>&1; then
	exec bash -lc "$CLIP_CMD | dmenu -i -p 'Clipboard' | cliphist decode | wl-copy"
fi

if command -v fzf >/dev/null 2>&1; then
	exec bash -lc "$CLIP_CMD | fzf --reverse | cliphist decode | wl-copy"
fi

# No chooser found
echo "No chooser (tofi/rofi/dmenu/fzf) found in PATH" >&2
exit 1
