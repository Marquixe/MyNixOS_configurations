#!/usr/bin/env bash

SAVE_DIR="$HOME/Work/guichko"
TMPIMG="$SAVE_DIR/$(date +%Y-%m-%d_%H-%M-%S).png"

# зберегти скрін (як було раніше)
grimblast save screen "$TMPIMG"

# відправити в Claude (фоново)
python3 "$HOME/.config/hypr/ask-claude/ask-claude.py" "$TMPIMG" &
