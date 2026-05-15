#!/usr/bin/env bash

if hyprctl clients -j | grep -q '"class": "spotify-player"'; then
    # вже запущений — просто показати і дати фокус
    hyprctl dispatch togglespecialworkspace spotify-player
    sleep 0.1
    hyprctl dispatch focuswindow class:spotify-player
else
    # запустити вперше
    kitty \
        --class spotify-player \
        --override background_opacity=0.80 \
        --override font_size=11 \
        --override window_padding_width=10 \
        --title "spotify-player" \
        ~/.config/hypr/spotify-player.sh &
fi
