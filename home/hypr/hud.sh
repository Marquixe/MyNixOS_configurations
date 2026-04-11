#!/usr/bin/env bash
SESSION="hud"

# Pick a random animation
ANIMATIONS=(
    "asciiquarium"
    "cmatrix -C cyan"
    "cbonsai -l -i"
    "pipes.sh -p 5 -R -C -K -r 0 -t 0 -t 1 -t 2 -t 3 -t 4 -t 5 -t 6 -t 7 -t 8 -t 9"
    "lavat -r 3"
    "snowmachine snow --speed=5" # --stack=pile
    #"gping google.com"
    #"mapscii"
)
PICK="${ANIMATIONS[$RANDOM%${#ANIMATIONS[@]}]}"

tmux kill-session -t $SESSION 2>/dev/null
sleep 0.2
tmux split-window -t $SESSION:0.2 -v -l 45 "$PICK"

tmux new-session -d -s $SESSION -x 220 -y 98 "tty-clock -s -c -C 6 -f ''"
# vertical stack
DATE_PANE=$(tmux split-window -dP -F "#{pane_id}" -t "$SESSION:0.0" -v -l 80 "bash ~/.config/hypr/hud-date.sh")
STATS_PANE=$(tmux split-window -dP -F "#{pane_id}" -t "$DATE_PANE" -v -l 65 "bash ~/.config/hypr/hud-stats.sh")
ANIM_PANE=$(tmux split-window -dP -F "#{pane_id}" -t "$STATS_PANE" -v -l 45 "$PICK")

# split date row
tmux split-window -d -t "$DATE_PANE" -h -b -p 33 ""
tmux split-window -d -t "$DATE_PANE" -h -p 50 "bash ~/.config/hypr/hud-updates.sh"

# split stats row
tmux split-window -d -t "$STATS_PANE" -h "gping google.com"

tmux set-option -t $SESSION status off
tmux set-option -t $SESSION pane-border-style fg=black
tmux set-option -t $SESSION pane-active-border-style fg=black
tmux attach-session -t $SESSION
