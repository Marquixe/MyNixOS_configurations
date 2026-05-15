#!/usr/bin/env bash

PLAYER_CLASS="spotify-player"

# check if already running
if hyprctl clients -j | grep -q '"class": "spotify-player"'; then
    hyprctl dispatch closewindow class:spotify-player
else
    kitty \
        --class spotify-player \
        --override background_opacity=0.75 \
        --override font_size=11 \
        --override window_padding_width=8 \
        --title "spotify-player" \
        ~/.config/hypr/spotify-player.sh &
fi
