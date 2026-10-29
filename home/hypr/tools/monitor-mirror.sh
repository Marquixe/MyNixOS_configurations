#!/usr/bin/env bash
# Lua config: hyprctl eval (keyword is legacy, kept commented below)
# NOTE: `mirror` field is untested here; verify on the real HDMI setup.
hyprctl eval 'hl.monitor({ output = "eDP-1", mode = "1920x1080@60", position = "0x0", scale = 1 })'
hyprctl eval 'hl.monitor({ output = "HDMI-A-1", mode = "1920x1080@60", position = "0x0", scale = 1, mirror = "eDP-1" })'
# hyprctl keyword monitor "eDP-1,1920x1080@60,0x0,1"
# hyprctl keyword monitor "HDMI-A-1,1920x1080@60,0x0,1,mirror,eDP-1"
# hyprctl keyword monitor "HDMI-A-1,preferred,0x0,1,mirror,eDP-1"
