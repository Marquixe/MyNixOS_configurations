#!/usr/bin/env bash
# Transparent info bar — horizontal layout: clock | stats | date | updates
# Runs inside a short, wide, transparent kitty window at the bottom of the screen.
SESSION="hud-info"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

tmux kill-session -t $SESSION 2>/dev/null
sleep 0.1

# Layout within ~240 cols (1920px wide):
#   clock(40) | stats(90) | date(50) | updates(remaining)
#
# Using absolute -l values within -x 240 initial size
tmux new-session -d -s $SESSION -x 240 -y 14 \
	"tty-clock -s -c -C 6 -f ''"

STATS_PANE=$(tmux split-window -dP -F "#{pane_id}" -t "$SESSION:0.0" -h -l 195 \
	"bash $SCRIPT_DIR/stats-compact.sh")

DATE_PANE=$(tmux split-window -dP -F "#{pane_id}" -t "$STATS_PANE" -h -l 100 \
	"bash $SCRIPT_DIR/date-compact.sh")

tmux split-window -d -t "$DATE_PANE" -h -l 50 \
	"bash $SCRIPT_DIR/updates-compact.sh"

tmux set-option -t $SESSION status off
tmux set-option -t $SESSION pane-border-style "fg=#1e1e2e"
tmux set-option -t $SESSION pane-active-border-style "fg=#1e1e2e"
tmux attach-session -t $SESSION
