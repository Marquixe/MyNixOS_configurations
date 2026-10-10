#!/usr/bin/env bash
# Exact same layout as hud_old, but the animation pane is empty.
# Loops forever — when tmux session is killed (reload), it restarts.
while true; do
	SESSION="hud-info"
	tmux kill-session -t $SESSION 2>/dev/null
	sleep 0.2

	tmux new-session -d -s $SESSION -x 220 -y 98 "peaclock --config-dir ~/.config/peaclock"

	DATE_PANE=$(tmux split-window -dP -F "#{pane_id}" -t "$SESSION:0.0" -v -l 80 "bash ~/.config/hypr/hud-date.sh")
	STATS_PANE=$(tmux split-window -dP -F "#{pane_id}" -t "$DATE_PANE" -v -l 65 "bash ~/.config/hypr/hud-stats.sh")

	# empty pane where animation would be — transparent
	tmux split-window -d -t "$STATS_PANE" -v -l 45 ""

	# split date row
	tmux split-window -d -t "$DATE_PANE" -h -b -p 33 ""
	tmux split-window -d -t "$DATE_PANE" -h -p 50 "bash ~/.config/hypr/hud-updates.sh"

	# split stats row
	tmux split-window -d -t "$STATS_PANE" -h "gping google.com"

	tmux set-option -t $SESSION status off
	tmux set-option -t $SESSION pane-border-style fg=black
	tmux set-option -t $SESSION pane-active-border-style fg=black
	tmux attach-session -t $SESSION

	sleep 0.5
done
