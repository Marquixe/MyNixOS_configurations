#!/usr/bin/env bash
# hud_cinema — animation-first HUD layout (sidebar)
# Uses absolute -l values within -x 220 -y 98 so tmux scales proportionally.
SESSION="hud"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

source ~/.config/hypr/hud-animations.sh

tmux kill-session -t $SESSION 2>/dev/null
sleep 0.2

# ── Create session — animation owns the full window ──────────────────────────
# 220x98 sets initial proportions; tmux rescales when kitty attaches
tmux new-session -d -s $SESSION -x 220 -y 98 "$PICK"
ANIM_PANE=$(tmux display-message -t "$SESSION:0.0" -p "#{pane_id}")

# ── Right sidebar (55 cols) ──────────────────────────────────────────────────
# Sidebar = 98 rows. Split pattern (same as old HUD — top-down absolute):
#   split -l N → top keeps (current - N - 1), bottom gets N
#
#   clock:   98 - 87 - 1 = 10 rows
#   date:    87 - 78 - 1 =  8 rows
#   stats:   78 - 60 - 1 = 17 rows
#   playing: 60 - 51 - 1 =  8 rows
#   updates: 51 - 37 - 1 = 13 rows
#   gping:               = 37 rows

CLOCK=$(tmux split-window -dP -F "#{pane_id}" -t "$ANIM_PANE" -h -l 55 \
	"peaclock --config-dir ~/.config/peaclock")

DATE_PANE=$(tmux split-window -dP -F "#{pane_id}" -t "$CLOCK" -v -l 87 \
	"bash $SCRIPT_DIR/date.sh")

STATS_PANE=$(tmux split-window -dP -F "#{pane_id}" -t "$DATE_PANE" -v -l 78 \
	"bash $SCRIPT_DIR/stats.sh")

PLAYING_PANE=$(tmux split-window -dP -F "#{pane_id}" -t "$STATS_PANE" -v -l 60 \
	"bash $SCRIPT_DIR/now-playing.sh")

UPDATES_PANE=$(tmux split-window -dP -F "#{pane_id}" -t "$PLAYING_PANE" -v -l 51 \
	"bash $SCRIPT_DIR/updates.sh")

tmux split-window -d -t "$UPDATES_PANE" -v -l 37 "gping google.com"

# ── cbonsai special: triple-split the animation pane ─────────────────────────
if [[ "$PICK" == "cbonsai -l -i --life=46 --time=0,001" ]]; then
	S1=$((RANDOM + 903))
	S2=$((RANDOM + 234))
	S3=$((RANDOM + 653))
	tmux respawn-pane -t "$ANIM_PANE" -k "sleep 1; $PICK -s $S1 --wait=3.07"
	tmux split-window -d -t "$ANIM_PANE" -h -b -p 33 "sleep 1; $PICK -s $S2 --wait=3.33"
	tmux split-window -d -t "$ANIM_PANE" -h -p 50 "sleep 1; $PICK -s $S3 --wait=3.71"
fi

# ── Style — invisible borders ────────────────────────────────────────────────
tmux set-option -t $SESSION status off
tmux set-option -t $SESSION pane-border-style "fg=#1e1e2e"
tmux set-option -t $SESSION pane-active-border-style "fg=#1e1e2e"
tmux attach-session -t $SESSION
