#!/usr/bin/env bash
# Плавна зміна Hyprland cursor zoom factor
STEP="$1"
MIN=1.0
MAX=5.0

CURRENT=$(hyprctl getoption cursor:zoom_factor | grep -oP '(?<=float: )[0-9.]+')
NEW=$(awk -v cur="$CURRENT" -v step="$STEP" -v min="$MIN" -v max="$MAX" \
    'BEGIN { v = cur + step; if (v < min) v = min; if (v > max) v = max; printf "%.2f", v }')

hyprctl keyword cursor:zoom_factor "$NEW"
