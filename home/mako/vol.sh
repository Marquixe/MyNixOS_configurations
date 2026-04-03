#!/usr/bin/env bash

ACTION=$1

case "$ACTION" in
up) wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ ;;
down) wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- ;;
mute) wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle ;;
esac

RAW=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
PERCENT=$(echo "$RAW" | awk '{printf "%d", $2 * 100}')
MUTED=$(echo "$RAW" | grep -c "MUTED")

BAR_FILLED=$((PERCENT / 5))
BAR_EMPTY=$((20 - BAR_FILLED))
BAR=$(printf '█%.0s' $(seq 1 $BAR_FILLED))$(printf '░%.0s' $(seq 1 $BAR_EMPTY))

if [ "$MUTED" -gt 0 ]; then
    ICON="🔇"
    BAR=$(printf '░%.0s' $(seq 1 20))
else
    ICON="🔊"
fi

notify-send -t 1500 \
    -h string:synchronize:volume \
    "$ICON Volume  ${PERCENT}%" \
    "$BAR"
