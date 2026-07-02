#!/usr/bin/env bash
# Extracts color3 (index 3) from the active terminal theme
# and writes it to ~/.config/tmux/colors.conf
# Usage: run after changing your terminal theme

OUTPUT="$HOME/.config/tmux/colors.conf"

extract_alacritty() {
    local file="$HOME/.config/omarchy/current/theme/alacritty.toml"
    # Alacritty TOML: normal.yellow = "#rrggbb"
    grep -A20 '^\[colors\.normal\]' "$file" \
        | grep 'yellow' \
        | head -1 \
        | grep -oP '#[0-9a-fA-F]{6}'
}

extract_ghostty() {
    local config="$HOME/.config/ghostty/config"
    local theme
    theme=$(grep -E '^\s*theme\s*=' "$config" | tail -1 | sed 's/.*=\s*//' | tr -d ' "')
    # Handle dark:Name,light:Name syntax
    theme=$(echo "$theme" | sed 's/.*dark:\([^,]*\).*/\1/' | sed 's/.*,//')
    local theme_file="/Applications/Ghostty.app/Contents/Resources/ghostty/themes/$theme"
    if [[ ! -f "$theme_file" ]]; then
        # Try user themes
        theme_file="$HOME/.config/ghostty/themes/$theme"
    fi
    grep -E '^\s*palette\s*=\s*3=' "$theme_file" \
        | grep -oP '#[0-9a-fA-F]{6}'
}

if [[ "$OSTYPE" == "darwin"* ]]; then
    COLOR=$(extract_ghostty)
else
    COLOR=$(extract_alacritty)
fi

if [[ -z "$COLOR" ]]; then
    echo "Could not extract color. Check your theme file." >&2
    exit 1
fi

echo "set -g @accent '$COLOR'" > "$OUTPUT"
echo "Wrote accent $COLOR to $OUTPUT"
