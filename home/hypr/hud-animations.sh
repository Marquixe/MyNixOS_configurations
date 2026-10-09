#!/usr/bin/env bash
# Shared animation list — sourced by all HUD variants.
# Edit this one file to change animations everywhere.

PLAYER="python3 ~/Work/srandik/term_ascii_art/render_symbol/hud_play.py"
ZST="~/Work/srandik/term_ascii_art/zst_files"
ZST_OV="~/Work/srandik/term_ascii_art/zst_files/overlay"

ANIMATIONS=(
	"asciiquarium"
	"cmatrix -C cyan"
	"cbonsai -l -i --life=46 --time=0,001"
	"snowmachine snow --speed=5"
	"python3 ~/Work/srandik/term_ascii_art/witch_craft/cauldron2.py"

	# ── standard (207x56 / 233x63) ──────────────────────────────────────
	"$PLAYER $ZST/jellyfish.color.zst"
	"$PLAYER $ZST/bad_apple.color.zst"
	"$PLAYER $ZST/black_hole.color.zst"
	"$PLAYER $ZST/tall_tree.color.zst"
	"$PLAYER $ZST/flovers_on_roots.color.zst"

	#"$PLAYER $ZST/neon_eyes.color.zst"
	#"$PLAYER $ZST/looking_skull.color.zst"
	#"$PLAYER $ZST/spinning_skull.color.zst"
	#"$PLAYER $ZST/thunder.color.zst"

	# ── overlay size (320x90) ────────────────────────────────────────────
	"$PLAYER $ZST_OV/blood_kitty.color.zst"
	"$PLAYER $ZST_OV/jelly.color.zst"
)

PICK="${ANIMATIONS[$RANDOM%${#ANIMATIONS[@]}]}"
