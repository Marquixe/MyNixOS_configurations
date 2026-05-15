#!/usr/bin/env bash

hide_player() {
    hyprctl dispatch togglespecialworkspace spotify-player
}

while true; do
    STATUS=$(playerctl status 2>/dev/null)

    if [[ "$STATUS" == "" ]]; then
        clear
        echo ""
        echo "  󰓇  spotify offline"
        echo ""
        sleep 3
        continue
    fi

    TITLE=$(playerctl metadata title 2>/dev/null | cut -c1-30)
    ARTIST=$(playerctl metadata artist 2>/dev/null | cut -c1-25)
    ALBUM=$(playerctl metadata album 2>/dev/null | cut -c1-25)

    POSITION=$(playerctl position 2>/dev/null)
    DURATION=$(playerctl metadata mpris:length 2>/dev/null)

    # convert microseconds to seconds
    DUR_SEC=$(echo "$DURATION / 1000000" | bc 2>/dev/null)
    POS_INT=${POSITION%.*}

    # format time
    fmt_time() {
        printf "%d:%02d" $(($1 / 60)) $(($1 % 60))
    }

    POS_FMT=$(fmt_time $POS_INT)
    DUR_FMT=$(fmt_time $DUR_SEC)

    # progress bar
    BAR_WIDTH=24
    if [[ $DUR_SEC -gt 0 ]]; then
        FILLED=$((POS_INT * BAR_WIDTH / DUR_SEC))
    else
        FILLED=0
    fi
    BAR=""
    for ((i = 0; i < BAR_WIDTH; i++)); do
        if [[ $i -lt $FILLED ]]; then
            BAR+="─"
        elif [[ $i -eq $FILLED ]]; then
            BAR+="●"
        else
            BAR+="─"
        fi
    done

    if [[ "$STATUS" == "Playing" ]]; then
        ICON=""
    else
        ICON=""
    fi

    SHUFFLE=$(playerctl shuffle 2>/dev/null)
    LOOP=$(playerctl loop 2>/dev/null)
    [[ "$SHUFFLE" == "On" ]] && SH_ICON="󰒟" || SH_ICON="󰒞"
    [[ "$LOOP" == "Track" ]] && LP_ICON="󰑘" || LP_ICON="󰑖"

    clear
    echo ""
    printf "  󰓇  %-30s\n" "$TITLE"
    printf "      %-25s\n" "$ARTIST"
    [[ -n "$ALBUM" ]] && printf "      %-25s\n" "$ALBUM"
    echo ""
    printf "   %s  %s  %s\n" "$POS_FMT" "$BAR" "$DUR_FMT"
    echo ""
    printf "   %s    %s   %s   ⏮    %s   ⏭\n" "$SH_ICON" "$LP_ICON" "$ICON"
    echo ""
    printf "   [q]uit  [space] play/pause  [n]ext  [p]rev\n"
    echo ""

    # non-blocking input
    read -t 1 -s -k 1 KEY 2>/dev/null
    case "$KEY" in
    " ") playerctl play-pause ;;
    "n") playerctl next ;;
    "p") playerctl previous ;;
    "s") playerctl shuffle toggle ;;
    "l") playerctl loop toggle ;; # none→track→playlist
    "q")
        hide_player
        break
        ;;
    esac

done
