#!/usr/bin/env bash
# ~/.config/hypr/hud-date.sh
# Centered date display — updates every second, no blinking

WHT=$'\e[1;37m'
DIM=$'\e[2m'
CYN=$'\e[0;36m'
RST=$'\e[0m'

tput civis

while true; do
  cols=$(tput cols)
  rows=$(tput lines)

  date_str=$(LC_TIME=en_US.UTF-8 date '+%A,  %d %B %Y')
  date_len=${#date_str}
  date_pad=$(( (cols - date_len) / 2 ))

  # vertically center in the pane
  top_pad=$(( (rows - 1) / 2 ))

  printf '\e[H\e[J'

  # blank lines to vertically center
  for (( i=0; i<top_pad; i++ )); do echo ""; done

  printf "%${date_pad}s${WHT}%s${RST}\n" "" "$date_str"

  sleep 1
done
