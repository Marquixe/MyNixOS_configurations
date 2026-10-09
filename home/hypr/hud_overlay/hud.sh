#!/usr/bin/env bash
# hud_overlay — fullscreen animation + transparent info bar on top
# Launches two kitty windows:
#   hud-anim-kitty    — fullscreen animation (opaque)
#   hud-info-kitty    — bottom info strip (transparent, sees animation through)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Kill old instances
hyprctl dispatch closewindow "class:hud-anim-kitty" 2>/dev/null
hyprctl dispatch closewindow "class:hud-info-kitty" 2>/dev/null
sleep 0.2

# Animation window (fullscreen behind)
kitty --class hud-anim-kitty -e bash "$SCRIPT_DIR/anim.sh" &

sleep 0.3

# Info overlay (transparent strip at bottom)
kitty --class hud-info-kitty -e bash "$SCRIPT_DIR/info.sh" &
