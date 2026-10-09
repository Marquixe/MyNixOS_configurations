#!/usr/bin/env bash
SESSION="hud"

source ~/.config/hypr/hud-animations.sh

tmux kill-session -t $SESSION 2>/dev/null
sleep 0.2
tmux split-window -t $SESSION:0.2 -v -l 45 "$PICK"

tmux new-session -d -s $SESSION -x 220 -y 98 "tty-clock -s -c -C 6 -f ''"
# vertical stack
DATE_PANE=$(tmux split-window -dP -F "#{pane_id}" -t "$SESSION:0.0" -v -l 80 "bash ~/.config/hypr/hud-date.sh")
STATS_PANE=$(tmux split-window -dP -F "#{pane_id}" -t "$DATE_PANE" -v -l 65 "bash ~/.config/hypr/hud-stats.sh")
#ANIM_PANE=$(tmux split-window -dP -F "#{pane_id}" -t "$STATS_PANE" -v -l 45 "$PICK")

if [[ "$PICK" == "cbonsai -l -i --life=46 --time=0,001" ]]; then
	S1=$((RANDOM + 903))
	S2=$((RANDOM + 234))
	S3=$((RANDOM + 653))
	ANIM_PANE=$(tmux split-window -dP -F "#{pane_id}" -t "$STATS_PANE" -v -l 45 "sleep 1; $PICK -s $S1 --wait=3.07")
	tmux split-window -d -t "$ANIM_PANE" -h -b -p 33 "sleep 1; $PICK -s $S2 --wait=3.33"
	tmux split-window -d -t "$ANIM_PANE" -h -p 50 "sleep 1; $PICK -s $S3 --wait=3.71"
else
	tmux split-window -d -t "$STATS_PANE" -v -l 45 "$PICK"
fi

# split date row
tmux split-window -d -t "$DATE_PANE" -h -b -p 33 ""
tmux split-window -d -t "$DATE_PANE" -h -p 50 "bash ~/.config/hypr/hud-updates.sh"

# split stats row
tmux split-window -d -t "$STATS_PANE" -h "gping google.com"

tmux set-option -t $SESSION status off
tmux set-option -t $SESSION pane-border-style fg=black
tmux set-option -t $SESSION pane-active-border-style fg=black
tmux attach-session -t $SESSION
