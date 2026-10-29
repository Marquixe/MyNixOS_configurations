#!/usr/bin/env bash
# Compact date + uptime — fits in a narrow sidebar pane
WHT=$'\e[1;37m'
DIM=$'\e[2m'
CYN=$'\e[0;36m'
RST=$'\e[0m'

tput civis

while true; do
	cols=$(tput cols)
	rows=$(tput lines)

	date_str=$(LC_TIME=en_US.UTF-8 date '+%a, %d %b %Y')
	up_str="up $(uptime -p | sed 's/^up //')"

	top_pad=$(( (rows - 2) / 2 ))

	printf '\e[H\e[J'
	for (( i=0; i<top_pad; i++ )); do echo ""; done

	# center date
	pad=$(( (cols - ${#date_str}) / 2 ))
	(( pad < 0 )) && pad=0
	printf "%*s${WHT}%s${RST}\n" "$pad" "" "$date_str"

	# center uptime below
	pad=$(( (cols - ${#up_str}) / 2 ))
	(( pad < 0 )) && pad=0
	printf "%*s${DIM}%s${RST}\n" "$pad" "" "$up_str"

	sleep 5
done
