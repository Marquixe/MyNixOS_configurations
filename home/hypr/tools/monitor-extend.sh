#!/usr/bin/env bash
# Lua config: hyprctl eval (keyword is legacy, kept commented below)
hyprctl eval 'hl.monitor({ output = "eDP-1", mode = "1920x1080@60", position = "0x0", scale = 1 })'
hyprctl eval 'hl.monitor({ output = "HDMI-A-1", mode = "1920x1080@60", position = "1920x0", scale = 1 })'
# hyprctl keyword monitor "eDP-1,1920x1080@60,0x0,1"
# hyprctl keyword monitor "HDMI-A-1,1920x1080@60,1920x0,1"
# hyprctl keyword monitor "HDMI-A-1,preferred,1920x0,1"
