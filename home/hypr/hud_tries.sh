#!/usr/bin/env bash
SESSION="hud"

# Висоти верхніх панелей (рядки). Хочеш більшу анімацію, зменшуй ці числа.
H_CLOCK=7
H_DATE=3
H_STATS=8

ANIMATIONS=(
	"asciiquarium"
	"cmatrix -C cyan"
	"cbonsai -l -i --life=46 --time=0,001"
	"snowmachine snow --speed=5"
	"python3 ~/Work/srandik/term_ascii_art/witch_craft/cauldron2.py"
	"python3 ~/Work/srandik/term_ascii_art/render_symbol/hud_play.py ~/Work/srandik/term_ascii_art/zst_files/jellyfish.color.zst"
)
PICK="${ANIMATIONS[$RANDOM%${#ANIMATIONS[@]}]}"

tmux kill-session -t $SESSION 2>/dev/null
sleep 0.2

# Реальний розмір твого терміналу, а не фіксовані 220x98.
COLS=$(tput cols)
ROWS=$(tput lines)

# 1. Анімаційна панель створюється першою і займає все вікно.
if [[ "$PICK" == "cbonsai"* ]]; then
	S1=$((RANDOM + 903))
	S2=$((RANDOM + 234))
	S3=$((RANDOM + 653))
	ANIM_PANE=$(tmux new-session -d -P -F "#{pane_id}" -s $SESSION -x "$COLS" -y "$ROWS" \
		"sleep 1; $PICK -s $S1 --wait=3.07")
else
	ANIM_PANE=$(tmux new-session -d -P -F "#{pane_id}" -s $SESSION -x "$COLS" -y "$ROWS" "$PICK")
fi

# 2. Решту додаємо ЗВЕРХУ (-b), кожна забирає місце в анімації.
STATS_PANE=$(tmux split-window -dP -F "#{pane_id}" -t "$ANIM_PANE" -v -b -l $H_STATS "bash ~/.config/hypr/hud-stats.sh")
DATE_PANE=$(tmux split-window -dP -F "#{pane_id}" -t "$STATS_PANE" -v -b -l $H_DATE "bash ~/.config/hypr/hud-date.sh")
tmux split-window -d -t "$DATE_PANE" -v -b -l $H_CLOCK "tty-clock -s -c -C 6 -f ''"

# 3. Горизонтальні поділи (після вертикальних, інакше вони зачеплять лише одну панель).
if [[ "$PICK" == "cbonsai"* ]]; then
	tmux split-window -d -t "$ANIM_PANE" -h -b -p 33 "sleep 1; $PICK -s $S2 --wait=3.33"
	tmux split-window -d -t "$ANIM_PANE" -h -p 50 "sleep 1; $PICK -s $S3 --wait=3.71"
fi

tmux split-window -d -t "$DATE_PANE" -h -b -p 33 ""
tmux split-window -d -t "$DATE_PANE" -h -p 50 "bash ~/.config/hypr/hud-updates.sh"
tmux split-window -d -t "$STATS_PANE" -h "gping google.com"

tmux set-option -t $SESSION status off
tmux set-option -t $SESSION pane-border-style fg=black
tmux set-option -t $SESSION pane-active-border-style fg=black
tmux attach-session -t $SESSION
