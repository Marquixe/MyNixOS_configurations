#!/usr/bin/env bash

BAT="/sys/class/power_supply/BAT0"
LAST_STATE=$(cat "$BAT/status")
LAST_NOTIFIED=""

udevadm monitor --subsystem-match=power_supply --udev | while read -r line; do
    [[ "$line" != *"power_supply"* ]] && continue

    sleep 2  # wait for state to fully settle
    PERCENT=$(cat "$BAT/capacity")
    STATE=$(cat "$BAT/status")

    [ "$STATE" = "$LAST_STATE" ] && continue

    if [ "$STATE" = "Charging" ]; then
        notify-send -t 2000 "⚡ Charging" "Plugged in at ${PERCENT}%"
    fi

    if [ "$STATE" = "Discharging" ]; then
        notify-send -t 2000 "🔋 Unplugged" "On battery at ${PERCENT}%"
        LAST_NOTIFIED=""
    fi

    if [ "$STATE" = "Discharging" ]; then
        THRESHOLD=$(( (PERCENT / 20) * 20 ))
        if [ "$THRESHOLD" != "$LAST_NOTIFIED" ]; then
            notify-send -t 8000 "🔋 Battery" "${PERCENT}% remaining"
            LAST_NOTIFIED="$THRESHOLD"
        fi
    fi

    LAST_STATE="$STATE"
done
