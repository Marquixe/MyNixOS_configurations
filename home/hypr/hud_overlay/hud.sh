#!/usr/bin/env bash
# hud_overlay — fullscreen animation + transparent info overlay
# First call: spawns both kitty windows
# Subsequent calls: kills tmux sessions, the while-loops restart them
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Check if kitty windows already exist
anim_exists=$(hyprctl clients -j 2>/dev/null | grep -c "hud-anim-kitty")
info_exists=$(hyprctl clients -j 2>/dev/null | grep -c "hud-info-kitty")

if [[ $anim_exists -gt 0 && $info_exists -gt 0 ]]; then
	# ── Reload: kill tmux sessions, while-loops in anim.sh/info.sh restart ─
	tmux kill-session -t hud-anim 2>/dev/null
	tmux kill-session -t hud-info 2>/dev/null
else
	# ── First launch: spawn kitty windows ──────────────────────────────────
	pkill -f 'kitty --class hud-anim-kitty' 2>/dev/null
	pkill -f 'kitty --class hud-info-kitty' 2>/dev/null
	tmux kill-session -t hud-anim 2>/dev/null
	tmux kill-session -t hud-info 2>/dev/null
	sleep 0.3

	kitty --class hud-anim-kitty -o background_opacity=0 -o font_size=6 -e bash "$SCRIPT_DIR/anim.sh" &
	sleep 0.5
	kitty --class hud-info-kitty -o background_opacity=0 -e bash "$SCRIPT_DIR/info.sh" &
fi
