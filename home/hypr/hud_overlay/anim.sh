#!/usr/bin/env bash
# Fullscreen animation player — always uses tmux so reload is reliable.
# Loops forever — when tmux session is killed (reload), picks a new animation.
SESSION="hud-anim"

while true; do
	source ~/.config/hypr/hud-animations.sh
	tmux kill-session -t $SESSION 2>/dev/null
	sleep 0.2

	if [[ "$PICK" == "cbonsai"* ]]; then
		S1=$((RANDOM + 903))
		S2=$((RANDOM + 234))
		S3=$((RANDOM + 653))
		tmux new-session -d -s $SESSION "sleep 1; $PICK -s $S1 --wait=3.07"
		tmux split-window -d -t "$SESSION:0.0" -h -b -p 33 "sleep 1; $PICK -s $S2 --wait=3.33"
		tmux split-window -d -t "$SESSION:0.0" -h -p 50 "sleep 1; $PICK -s $S3 --wait=3.71"
	else
		tmux new-session -d -s $SESSION "$PICK"
	fi

	tmux set-option -t $SESSION status off
	tmux set-option -t $SESSION pane-border-style "fg=#1e1e2e"
	tmux set-option -t $SESSION pane-active-border-style "fg=#1e1e2e"
	tmux attach-session -t $SESSION

	sleep 0.5
done
