#!/usr/bin/env bash
# ~/.config/hypr/hud-stats.sh

RED=$'\e[0;31m'
GRN=$'\e[0;32m'
YLW=$'\e[0;33m'
BLU=$'\e[0;34m'
MAG=$'\e[0;35m'
CYN=$'\e[0;36m'
WHT=$'\e[1;37m'
DIM=$'\e[2m'
BLD=$'\e[1m'
RST=$'\e[0m'

get_cpu() {
  local a b
  read -ra a < /proc/stat
  sleep 0.5
  read -ra b < /proc/stat
  local idle1=$(( a[4]+a[5] )) total1=0
  local idle2=$(( b[4]+b[5] )) total2=0
  for v in "${a[@]:1}"; do (( total1+=v )); done
  for v in "${b[@]:1}"; do (( total2+=v )); done
  local di=$(( idle2-idle1 )) dt=$(( total2-total1 ))
  (( dt==0 )) && echo 0 || echo $(( 100*(dt-di)/dt ))
}

get_ram() {
  local total avail
  total=$(awk '/MemTotal/    {print $2}' /proc/meminfo)
  avail=$(awk '/MemAvailable/{print $2}' /proc/meminfo)
  echo "$(( (total-avail)/1024 )) MB / $(( total/1024 )) MB"
}

get_battery() {
  local bat="/sys/class/power_supply/BAT0"
  [[ ! -d $bat ]] && echo "no battery" && return
  local cap status icon
  cap=$(cat "$bat/capacity")
  status=$(cat "$bat/status")
  case "$status" in
    Charging)    icon="⚡ charging"   ;;
    Discharging) icon="🔋 on battery" ;;
    Full)        icon="✅ full"        ;;
    *)           icon="$status"       ;;
  esac
  echo "${cap}%  ${icon}"
}

_net_bytes() {
  local iface
  iface=$(ip route get 1.1.1.1 2>/dev/null \
    | awk '{for(i=1;i<=NF;i++) if($i=="dev"){print $(i+1);exit}}')
  [[ -z $iface ]] && echo "0 0" && return
  echo "$(cat /sys/class/net/$iface/statistics/rx_bytes 2>/dev/null || echo 0) \
        $(cat /sys/class/net/$iface/statistics/tx_bytes 2>/dev/null || echo 0)"
}

fmt_speed() {
  local b=$(( $1 + 0 ))
  if   (( b >= 1048576 )); then awk "BEGIN{printf \"%.1f MB/s\",$b/1048576}"
  elif (( b >= 1024 ));    then echo "$(( b/1024 )) KB/s"
  else                          echo "${b} B/s"
  fi
}

bar() {
  local pct=$(( $1 + 0 )) len=${2:-40}
  (( pct > 100 )) && pct=100
  local filled=$(( pct*len/100 ))
  local empty=$(( len-filled ))
  local color
  (( pct >= 80 )) && color=$RED || (( pct >= 50 )) && color=$YLW || color=$GRN
  printf "${color}["
  for (( i=0; i<filled; i++ )); do printf '█'; done
  printf "${DIM}"
  for (( i=0; i<empty;  i++ )); do printf '░'; done
  printf "${RST}${color}]${RST}"
}

tput civis

cols=$(tput cols)
#sep="${DIM}${CYN}$(printf '─%.0s' $(seq 1 $cols))${RST}"

printf '\e[H\e[J'
printf '%b\n' "$sep"

while true; do
  read -r rx1 tx1 <<< "$(_net_bytes)"
  cpu=$(get_cpu)
  read -r rx2 tx2 <<< "$(_net_bytes)"

  rx1=$(( rx1+0 )); rx2=$(( rx2+0 ))
  tx1=$(( tx1+0 )); tx2=$(( tx2+0 ))
  rx_spd=$(( (rx2-rx1)*2 )); (( rx_spd < 0 )) && rx_spd=0
  tx_spd=$(( (tx2-tx1)*2 )); (( tx_spd < 0 )) && tx_spd=0

  ram=$(get_ram)
  bat=$(get_battery)
  dl_str=$(fmt_speed $rx_spd)
  up_str=$(fmt_speed $tx_spd)

  printf '\e[2;1H\e[K'
  printf "  ${YLW}CPU${RST}  $(bar $cpu)  ${WHT}%3d%%${RST}" $cpu

  printf '\e[3;1H\e[K'
  printf "  ${MAG}RAM${RST}  ${WHT}%s${RST}     ${CYN}BAT${RST}  ${WHT}%s${RST}" "$ram" "$bat"

  printf '\e[4;1H\e[K'
  printf "  ${BLU}NET${RST}  ${GRN}↓ %-14s${RST}  ${YLW}↑ %s${RST}" "$dl_str" "$up_str"
  (( rx_spd > 102400 )) && printf "   ${BLD}${GRN}● downloading${RST}"

  printf '\e[5;1H\e[K'
  printf '%b\n' #"$sep"

done
