#!/usr/bin/env bash

PLAYER="--player=spotify"

while true; do
    STATUS=$(playerctl $PLAYER status 2>/dev/null)

    if [[ -z "$STATUS" ]]; then
        clear
        printf "\n  spotify offline\n\n  waiting...\n"
        sleep 3
        continue
    fi

    TITLE=$(playerctl $PLAYER metadata title 2>/dev/null | cut -c1-35)
    ARTIST=$(playerctl $PLAYER metadata artist 2>/dev/null | cut -c1-30)

    POSITION=$(playerctl $PLAYER position 2>/dev/null)
    DURATION=$(playerctl $PLAYER metadata mpris:length 2>/dev/null)

    DUR_SEC=$((DURATION / 1000000))
    POS_INT=${POSITION%.*}

    fmt_time() { printf "%d:%02d" $(($1 / 60)) $(($1 % 60)); }

    POS_FMT=$(fmt_time $POS_INT)
    DUR_FMT=$(fmt_time $DUR_SEC)

    BAR_WIDTH=30

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

    SHUFFLE=$(playerctl $PLAYER shuffle 2>/dev/null)
    LOOP=$(playerctl $PLAYER loop 2>/dev/null)

    [[ "$SHUFFLE" == "On" ]] && SH="⤮ ON " || SH="⤮ OFF"

    #↻⟳⟲
    case "$LOOP" in
    "None") LOOP_STATE="↻ OFF" ;;
    "Playlist") LOOP_STATE="↻ ALL" ;;
    "Track") LOOP_STATE="↻ ONE" ;;
    *) LOOP_STATE="↻ OFF" ;;
    esac

    # play state icon
    if [[ "$STATUS" == "Playing" ]]; then
        PLAY_ICON="⏸"
    else
        PLAY_ICON="▶"
    fi

    clear

    # ─────────────────────────
    # TITLE / ARTIST
    # ─────────────────────────
    printf "\n"
    printf "  %-40s\n" "$TITLE"
    printf "  %-40s\n" "$ARTIST"

    # ─────────────────────────
    # PROGRESS BAR
    # ─────────────────────────
    printf "\n"
    printf "  %s  %s  %s\n" "$POS_FMT" "$BAR" "$DUR_FMT"

    # ─────────────────────────
    # TOP CONTROLS (ICONS ONLY)
    # ─────────────────────────
    printf "\n"
    printf "  %s      ⏮         %s         ⏭      %s\n" "$SH" "$PLAY_ICON" "$LOOP_STATE"
    # printf "\n"

    # ─────────────────────────
    # SECOND ROW (MODES)
    # ─────────────────────────
    # printf "       %s        %s\n" "$SH" "$LOOP_STATE"

    # # ─────────────────────────
    # # HELP LINE
    # # ─────────────────────────
    # printf "\n"
    # printf "   m=play/pause  ←/→=seek  s=shuffle  l=loop  q=quit\n"
    # printf "\n"

    # ─────────────────────────
    # INPUT
    # ─────────────────────────
    if read -rsn1 -t 0.2 KEY 2>/dev/tty; then
        if [[ "$KEY" == $'\e' ]]; then
            read -rsn2 -t 0.1 KEY2
            KEY+="$KEY2"
        fi

        case "$KEY" in
        "m") playerctl $PLAYER play-pause ;;
        $'\e[C') playerctl $PLAYER next ;;
        $'\e[D') playerctl $PLAYER previous ;;
        "s") playerctl $PLAYER shuffle toggle ;;
        "l")
            LOOP=$(playerctl $PLAYER loop 2>/dev/null)
            case "$LOOP" in
            "None") playerctl $PLAYER loop Playlist ;;
            "Playlist") playerctl $PLAYER loop Track ;;
            "Track") playerctl $PLAYER loop None ;;
            *) playerctl $PLAYER loop None ;;
            esac
            ;;
        "q")
            hyprctl dispatch togglespecialworkspace spotify-player
            break
            ;;
        esac
    fi

done
