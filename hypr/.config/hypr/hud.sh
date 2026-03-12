#!/usr/bin/env bash
SESSION="hud"

tmux kill-session -t $SESSION 2>/dev/null
sleep 0.2

tmux new-session -d -s $SESSION -x 220 -y 100 "tty-clock -s -c -C 6 -f ''"
tmux split-window -t $SESSION:0.0 -v -l 80 "bash ~/.config/hypr/hud-date.sh"
tmux split-window -t $SESSION:0.1 -v -l 65 "bash ~/.config/hypr/hud-stats.sh"
tmux split-window -t $SESSION:0.2 -v -l 45 "asciiquarium" #"cmatrix"

tmux set-option -t $SESSION status off
tmux set-option -t $SESSION pane-border-style fg=black
tmux set-option -t $SESSION pane-active-border-style fg=black

tmux attach-session -t $SESSION
