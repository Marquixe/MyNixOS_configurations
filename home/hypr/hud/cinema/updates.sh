#!/usr/bin/env bash
# Nix flake update checker — auto-centers in pane
WHT=$'\e[1;37m'
GRN=$'\e[0;32m'
YLW=$'\e[0;33m'
DIM=$'\e[2m'
RST=$'\e[0m'

updates_pipe=$(mktemp -u)
mkfifo "$updates_pipe"

cleanup() {
	tput cnorm 2>/dev/null
	[[ -n "${updater_pid:-}" ]] && kill "$updater_pid" 2>/dev/null
	rm -f "$updates_pipe"
}
trap cleanup EXIT INT TERM

_check_updates() {
	while true; do
		count=$(nix flake update --dry-run 2>&1 | grep -c "Updated input")
		printf '%s\n' "$count"
		sleep 600
	done
}

_check_updates >"$updates_pipe" &
updater_pid=$!

tput civis
count="..."

while true; do
	if read -t 0.1 new_count <"$updates_pipe"; then
		count="$new_count"
	fi

	cols=$(tput cols)
	rows=$(tput lines)
	top_pad=$(((rows - 1) / 2))

	tput cup 0 0
	tput ed

	for ((i = 0; i < top_pad; i++)); do printf '\n'; done

	if [[ "$count" == "..." ]]; then
		text="checking..."
		pad=$(((cols - ${#text}) / 2))
		((pad < 0)) && pad=0
		printf "%*s${DIM}%s${RST}\n" "$pad" "" "$text"
	elif [[ "$count" -eq 0 ]]; then
		text="nix: up to date"
		pad=$(((cols - ${#text}) / 2))
		((pad < 0)) && pad=0
		printf "%*s${GRN}%s${RST}\n" "$pad" "" "$text"
	else
		text="$count input(s) outdated"
		pad=$(((cols - ${#text}) / 2))
		((pad < 0)) && pad=0
		printf "%*s${YLW}%s${RST}\n" "$pad" "" "$text"
	fi

	sleep 5
done
