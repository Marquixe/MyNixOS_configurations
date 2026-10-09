#!/usr/bin/env bash
# Compact date + uptime — centered in pane
WHT=$'\e[1;37m'
DIM=$'\e[2m'
RST=$'\e[0m'

tput civis

while true; do
	cols=$(tput cols)
	rows=$(tput lines)
	top_pad=$(( (rows - 2) / 2 ))

	date_str=$(LC_TIME=en_US.UTF-8 date '+%A, %d %b %Y')
	up_str="up $(uptime -p | sed 's/^up //')"

	printf '\e[H\e[J'
	for (( i=0; i<top_pad; i++ )); do echo ""; done

	pad=$(( (cols - ${#date_str}) / 2 ))
	(( pad < 0 )) && pad=0
	printf "%*s${WHT}%s${RST}\n" "$pad" "" "$date_str"

	pad=$(( (cols - ${#up_str}) / 2 ))
	(( pad < 0 )) && pad=0
	printf "%*s${DIM}%s${RST}\n" "$pad" "" "$up_str"

	sleep 5
done
