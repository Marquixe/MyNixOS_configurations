#!/usr/bin/env bash
for i in 1 2 3 4 5; do
	hyprctl dispatch moveworkspacetomonitor "$i" eDP-1
done
for i in 6 7 8 9 10; do
	hyprctl dispatch moveworkspacetomonitor "$i" HDMI-A-1
done
