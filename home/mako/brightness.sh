#!/usr/bin/env bash

ACTION=$1

case "$ACTION" in
up) brightnessctl -e4 -n2 set 5%+ ;;
down) brightnessctl -e4 -n2 set 5%- ;;
esac

PERCENT=$(brightnessctl | grep -oP '\d+(?=%)' | tail -1)

BAR_FILLED=$((PERCENT / 5))
BAR_EMPTY=$((20 - BAR_FILLED))
BAR=$(printf '█%.0s' $(seq 1 $BAR_FILLED))$(printf '░%.0s' $(seq 1 $BAR_EMPTY))

notify-send -t 1500 \
    --app-name=brightness \
    "☀️ ${PERCENT}%  ${BAR}"
