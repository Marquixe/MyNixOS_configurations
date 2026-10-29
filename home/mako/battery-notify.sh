#!/usr/bin/env bash
# Battery watcher. Polls every minute: udev events don't fire reliably on
# every percent change, so the old udev-based loop missed warnings.
#   20%  → normal notification
#   10%  → critical (stays on screen)
#    5%  → critical (stays on screen)

BAT="/sys/class/power_supply/BAT0"
INTERVAL=60

LAST_STATE=""
WARNED=100   # lowest threshold already warned about while discharging

while true; do
    PERCENT=$(cat "$BAT/capacity")
    STATE=$(cat "$BAT/status")

    if [ "$STATE" != "$LAST_STATE" ]; then
        case "$STATE" in
            Charging)
                notify-send -t 2000 "⚡ Charging" "Plugged in at ${PERCENT}%"
                WARNED=100
                ;;
            Discharging)
                notify-send -t 2000 "🔋 Unplugged" "On battery at ${PERCENT}%"
                WARNED=100
                ;;
        esac
        LAST_STATE="$STATE"
    fi

    if [ "$STATE" = "Discharging" ]; then
        if [ "$PERCENT" -le 5 ] && [ "$WARNED" -gt 5 ]; then
            notify-send -u critical -t 0 "🪫 Battery critical" "${PERCENT}% — plug in NOW"
            WARNED=5
        elif [ "$PERCENT" -le 10 ] && [ "$WARNED" -gt 10 ]; then
            notify-send -u critical -t 0 "🪫 Battery low" "${PERCENT}% — plug in"
            WARNED=10
        elif [ "$PERCENT" -le 20 ] && [ "$WARNED" -gt 20 ]; then
            notify-send -t 8000 "🔋 Battery" "${PERCENT}% remaining"
            WARNED=20
        fi
    fi

    sleep "$INTERVAL"
done
