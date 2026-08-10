#!/usr/bin/env bash
# systemd-run + notify-send
set -euo pipefail

usage() {
    cat <<EOF
Usage: alarm <time> [massage]

  alarm 10m "Coffie time"
  alarm 1h30m "Ready up"
  alarm 14:30 "Lunch"
EOF
    exit 1
}

[[ $# -lt 1 ]] && usage

TIME="$1"
shift
MSG="${*:-Times up!}"

if [[ "$TIME" =~ ^[0-9]+(h[0-9]*)?(m[0-9]*)?(s[0-9]*)?$ ]] && [[ ! "$TIME" =~ : ]]; then
    TIMER_OPT="--on-active=${TIME}"
else
    TIMER_OPT="--on-calendar=${TIME}"
fi

systemd-run --user \
    "$TIMER_OPT" \
    --unit="alarm-$(date +%s%N)" \
    --description="alarm: ${MSG}" \
    notify-send -u critical -a "Alarm" "⏰" "$MSG"

echo "Time set: ${TIME} → ${MSG}"
