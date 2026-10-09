#!/usr/bin/env bash
# hud_cinema — animation-first HUD layout
# Animation takes the full left side, info stacked in a narrow right sidebar.
SESSION="hud"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

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

tmux kill-session -t $SESSION 2>/dev/null
sleep 0.2

# ── Create session — animation owns the full window ──────────────────────────
tmux new-session -d -s $SESSION -x 220 -y 98 "$PICK"
ANIM_PANE=$(tmux display-message -t "$SESSION:0.0" -p "#{pane_id}")

# ── Right sidebar (25% of width) ─────────────────────────────────────────────
CLOCK=$(tmux split-window -dP -F "#{pane_id}" -t "$ANIM_PANE" -h -p 25 \
	"tty-clock -s -c -C 6 -f ''")

# Stack info panes vertically inside the sidebar (all percentages so it scales)
#   clock ~10% | date ~9% | stats ~12% | playing ~10% | updates ~15% | gping ~44%
DATE_PANE=$(tmux split-window -dP -F "#{pane_id}" -t "$CLOCK" -v -p 90 \
	"bash $SCRIPT_DIR/date.sh")

STATS_PANE=$(tmux split-window -dP -F "#{pane_id}" -t "$DATE_PANE" -v -p 89 \
	"bash $SCRIPT_DIR/stats.sh")

PLAYING_PANE=$(tmux split-window -dP -F "#{pane_id}" -t "$STATS_PANE" -v -p 85 \
	"bash $SCRIPT_DIR/now-playing.sh")

UPDATES_PANE=$(tmux split-window -dP -F "#{pane_id}" -t "$PLAYING_PANE" -v -p 80 \
	"bash $SCRIPT_DIR/updates.sh")

tmux split-window -d -t "$UPDATES_PANE" -v -p 70 "gping google.com"

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
