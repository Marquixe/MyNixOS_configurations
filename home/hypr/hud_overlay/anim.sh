#!/usr/bin/env bash
# Fullscreen animation player
# For cbonsai: uses tmux for triple split. Everything else runs directly.
ANIMATIONS=(
	"asciiquarium"
	"cmatrix -C cyan"
	"cbonsai -l -i --life=46 --time=0,001"
	"snowmachine snow --speed=5"
	"python3 ~/Work/srandik/term_ascii_art/witch_craft/cauldron2.py"
	"python3 ~/Work/srandik/term_ascii_art/render_symbol/hud_play.py ~/Work/srandik/term_ascii_art/zst_files/jellyfish.color.zst"
	"python3 ~/Work/srandik/term_ascii_art/render_symbol/hud_play.py ~/Work/srandik/term_ascii_art/zst_files/bad_apple.color.zst"
	"python3 ~/Work/srandik/term_ascii_art/render_symbol/hud_play.py ~/Work/srandik/term_ascii_art/zst_files/black_hole.color.zst"
	"python3 ~/Work/srandik/term_ascii_art/render_symbol/hud_play.py ~/Work/srandik/term_ascii_art/zst_files/tall_tree.color.zst"
	"python3 ~/Work/srandik/term_ascii_art/render_symbol/hud_play.py ~/Work/srandik/term_ascii_art/zst_files/flovers_on_roots.color.zst"
)
PICK="${ANIMATIONS[$RANDOM%${#ANIMATIONS[@]}]}"

if [[ "$PICK" == "cbonsai"* ]]; then
	SESSION="hud-anim"
	tmux kill-session -t $SESSION 2>/dev/null
	S1=$((RANDOM + 903))
	S2=$((RANDOM + 234))
	S3=$((RANDOM + 653))
	tmux new-session -d -s $SESSION "sleep 1; $PICK -s $S1 --wait=3.07"
	tmux split-window -d -t "$SESSION:0.0" -h -b -p 33 "sleep 1; $PICK -s $S2 --wait=3.33"
	tmux split-window -d -t "$SESSION:0.0" -h -p 50 "sleep 1; $PICK -s $S3 --wait=3.71"
	tmux set-option -t $SESSION status off
	tmux set-option -t $SESSION pane-border-style "fg=#1e1e2e"
	tmux set-option -t $SESSION pane-active-border-style "fg=#1e1e2e"
	tmux attach-session -t $SESSION
else
	eval "$PICK"
fi
