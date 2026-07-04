#!/usr/bin/env bash
# wifi.sh — fzf WiFi manager (Tokyo Night)

# ── Tokyo Night palette ─────────────────────────────────────
BG="#1a1b26"
FG="#c0caf5"
BG2="#24283b"
PURPLE="#bb9af7"
BLUE="#7aa2f7"
GREEN="#9ece6a"
MUTED="#414868"

# ── ANSI (truecolor) ─────────────────────────────────────────
A_GREEN="\033[38;2;158;206;106m"
A_BLUE="\033[38;2;122;162;247m"
A_PURPLE="\033[38;2;187;154;247m"
A_YELLOW="\033[38;2;224;175;104m"
A_MUTED="\033[38;2;65;72;104m"
A_RESET="\033[0m"

# ── helpers ───────────────────────────────────────────────────
signal_icon() {
    if   [ "$1" -ge 75 ]; then printf "󰤨"
    elif [ "$1" -ge 50 ]; then printf "󰤥"
    elif [ "$1" -ge 25 ]; then printf "󰤢"
    else                       printf "󰤟"
    fi
}

signal_bars() {
    local s=$1 b=0 out=""
    [ "$s" -ge 25 ] && b=1
    [ "$s" -ge 50 ] && b=2
    [ "$s" -ge 75 ] && b=3
    [ "$s" -ge 90 ] && b=4
    for ((i=0;i<b;i++));    do out+="█"; done
    for ((i=b;i<4;i++));    do out+="░"; done
    printf "%s" "$out"
}

wifi_dev() {
    nmcli -t -f DEVICE,TYPE device status 2>/dev/null \
        | awk -F: '$2=="wifi"{print $1; exit}'
}

current_ssid() {
    nmcli -t -f ACTIVE,SSID dev wifi list 2>/dev/null \
        | while IFS= read -r l; do
            [[ "$l" == yes:* ]] && printf '%s' "${l#yes:}" && break
          done
}

# Parse terse nmcli line into ssid/signal/security
# sets $ssid $signal $security
parse_line() {
    local line="$1"
    security="${line##*:}"
    local tmp="${line%:*}"
    signal="${tmp##*:}"
    ssid="${tmp%:*}"
    ssid="${ssid//\\:/:}"   # unescape nmcli \: → :
}

# ── --list mode (initial load + ctrl-r reload) ───────────────
list_networks() {
    local current; current=$(current_ssid)
    declare -A seen
    while IFS= read -r line; do
        [ -z "$line" ] && continue
        local ssid signal security
        parse_line "$line"
        [ -z "$ssid" ] || [ "$ssid" = "--" ] && continue
        [ -n "${seen[$ssid]}" ] && continue
        seen[$ssid]=1

        local icon; icon=$(signal_icon "$signal")
        local lock=""; [[ "$security" != "--" && -n "$security" ]] && lock="󰌾 "

        if [ "$ssid" = "$current" ]; then
            printf "  %s  %s${A_GREEN}✓${A_RESET} %s\t%s\n" "$icon" "$lock" "$ssid" "$ssid"
        else
            printf "  %s  %s  %s\t%s\n" "$icon" "$lock" "$ssid" "$ssid"
        fi
    done < <(nmcli -t -f SSID,SIGNAL,SECURITY dev wifi list 2>/dev/null)
}

# ── --preview mode ────────────────────────────────────────────
preview_network() {
    local ssid="$1"

    # Find this network's signal + security
    local signal="" security=""
    while IFS= read -r line; do
        local s sig sec
        sec="${line##*:}"; local tmp="${line%:*}"; sig="${tmp##*:}"
        s="${tmp%:*}"; s="${s//\\:/:}"
        if [ "$s" = "$ssid" ]; then signal="$sig"; security="$sec"; break; fi
    done < <(nmcli -t -f SSID,SIGNAL,SECURITY dev wifi list 2>/dev/null)

    [ -z "$signal" ] && { echo "  not found"; exit 0; }

    local bars; bars=$(signal_bars "$signal")
    local saved="no"
    nmcli -t -f NAME connection show 2>/dev/null | grep -qFx "$ssid" && saved="yes"

    local current; current=$(current_ssid)
    local ip=""
    if [ "$ssid" = "$current" ]; then
        local dev; dev=$(wifi_dev)
        ip=$(nmcli -t -f IP4.ADDRESS dev show "$dev" 2>/dev/null \
            | head -1 | cut -d: -f2 | cut -d/ -f1)
    fi

    printf "\n"
    printf "  ${A_PURPLE}%s${A_RESET}\n\n" "$ssid"
    printf "  ${A_BLUE}signal  ${A_RESET} %s  %s%%\n" "$bars" "$signal"
    printf "  ${A_BLUE}security${A_RESET} %s\n" "${security:---}"
    printf "  ${A_BLUE}saved   ${A_RESET} %s\n" "$saved"
    if [ -n "$ip" ]; then
        printf "  ${A_BLUE}ip      ${A_RESET} ${A_GREEN}%s${A_RESET}\n" "$ip"
    fi
}

# ── flag dispatch ─────────────────────────────────────────────
case "$1" in
    --list)
        nmcli dev wifi rescan 2>/dev/null || true
        list_networks
        exit 0
        ;;
    --preview)
        preview_network "$2"
        exit 0
        ;;
esac

# ── main ──────────────────────────────────────────────────────
nmcli dev wifi rescan 2>/dev/null || true

current=$(current_ssid)
ip_info=""
if [ -n "$current" ]; then
    dev=$(wifi_dev)
    ip=$(nmcli -t -f IP4.ADDRESS dev show "$dev" 2>/dev/null \
        | head -1 | cut -d: -f2 | cut -d/ -f1)
    [ -n "$ip" ] && ip_info=" ($ip)"
fi

SCRIPT="$(realpath "$0")"

FZF_COLORS="bg:$BG,fg:$FG,hl:$BLUE,bg+:$BG2,fg+:$FG,hl+:$PURPLE"
FZF_COLORS+=",border:$MUTED,prompt:$PURPLE,pointer:$PURPLE"
FZF_COLORS+=",header:$GREEN,info:$MUTED,separator:$MUTED,gutter:$BG"
FZF_COLORS+=",preview-bg:$BG2"

selected=$(list_networks | fzf \
    --ansi \
    --delimiter=$'\t' \
    --with-nth=1 \
    --prompt="   " \
    --header="connected: ${current:-none}$ip_info" \
    --header-first \
    --color="$FZF_COLORS" \
    --border=rounded \
    --border-label="  WiFi " \
    --border-label-pos=3 \
    --padding="1,1" \
    --no-info \
    --height=100% \
    --preview="bash $SCRIPT --preview {2}" \
    --preview-window="right:38%:border-left" \
    --bind="ctrl-r:reload(bash $SCRIPT --list)+clear-query")

[ -z "$selected" ] && exit 0

ssid=$(printf '%s' "$selected" | cut -d$'\t' -f2)
clear; echo ""

# ── saved profile → reconnect ─────────────────────────────────
if nmcli -t -f NAME connection show 2>/dev/null | grep -qFx "$ssid"; then
    echo "  connecting to $ssid..."
    if nmcli connection up "$ssid" 2>/dev/null; then
        notify-send "󰖩 WiFi" "Connected to $ssid" 2>/dev/null || true
        echo "  connected!"
    else
        echo "  failed — try forgetting and reconnecting"
        sleep 2
    fi
    sleep 1; exit 0
fi

# ── new network ───────────────────────────────────────────────
security=""
while IFS= read -r line; do
    sec="${line##*:}"; tmp="${line%:*}"; sig="${tmp##*:}"; s="${tmp%:*}"; s="${s//\\:/:}"
    [ "$s" = "$ssid" ] && security="$sec" && break
done < <(nmcli -t -f SSID,SIGNAL,SECURITY dev wifi list 2>/dev/null)

if [[ -n "$security" && "$security" != "--" ]]; then
    printf "  ${A_PURPLE}󰌾  password for %s${A_RESET}\n  > " "$ssid"
    read -rs password
    echo; echo ""
    [ -z "$password" ] && echo "  cancelled" && sleep 1 && exit 0

    echo "  connecting..."
    if nmcli dev wifi connect "$ssid" password "$password" 2>/dev/null; then
        notify-send "󰖩 WiFi" "Connected to $ssid" 2>/dev/null || true
        echo "  connected!"
    else
        echo "  wrong password or connection failed"
        sleep 2
    fi
else
    echo "  connecting to $ssid..."
    if nmcli dev wifi connect "$ssid" 2>/dev/null; then
        notify-send "󰖩 WiFi" "Connected to $ssid" 2>/dev/null || true
        echo "  connected!"
    else
        echo "  connection failed"
        sleep 2
    fi
fi

sleep 1
