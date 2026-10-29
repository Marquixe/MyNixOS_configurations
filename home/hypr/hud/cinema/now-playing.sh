#!/usr/bin/env bash
# Now-playing widget — shows current track from playerctl
DIM=$'\e[2m'
CYN=$'\e[0;36m'
WHT=$'\e[1;37m'
MAG=$'\e[0;35m'
RST=$'\e[0m'

tput civis

while true; do
	cols=$(tput cols)
	rows=$(tput lines)
	mid=$(( (rows - 3) / 2 ))

	status=$(playerctl status 2>/dev/null || echo "Stopped")
	title=$(playerctl metadata title 2>/dev/null | head -c $((cols - 4)))
	artist=$(playerctl metadata artist 2>/dev/null | head -c $((cols - 4)))

	printf '\e[H\e[J'
	for (( i=0; i<mid; i++ )); do printf '\n'; done

	if [[ "$status" == "Playing" || "$status" == "Paused" ]]; then
		case "$status" in
			Playing) icon=">" ;;
			Paused)  icon="||" ;;
		esac

		# center title
		label="$icon $title"
		pad=$(( (cols - ${#label}) / 2 ))
		(( pad < 0 )) && pad=0
		printf "%*s${WHT}%s${RST}\n" "$pad" "" "$label"

		# center artist
		if [[ -n "$artist" ]]; then
			pad=$(( (cols - ${#artist}) / 2 ))
			(( pad < 0 )) && pad=0
			printf "%*s${DIM}%s${RST}\n" "$pad" "" "$artist"
		fi
	else
		label="no music"
		pad=$(( (cols - ${#label}) / 2 ))
		(( pad < 0 )) && pad=0
		printf "%*s${DIM}%s${RST}\n" "$pad" "" "$label"
	fi

	sleep 3
done
