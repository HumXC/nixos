#!/usr/bin/env bash

# origin: swww example script
# This script will randomly go through the files of a directory, setting it
# up as the wallpaper at regular intervals
#
# NOTE: this script is in bash (not posix shell), because the RANDOM variable
# we use is not defined in posix
dir=$HOME/Pictures/wallpaper
SWWWARGS='--transition-type wipe --transition-angle 30'
# Edit bellow to control the images transition
export SWWW_TRANSITION_FPS=160
export SWWW_TRANSITION_STEP=160
# This controls (in seconds) when to switch to the next image
INTERVAL=120
once="once"
if [ "$1" == "$once" ]; then
	find "$dir" |
		while read -r img; do
			if [ "$img" != "$dir" ]; then
				echo "$((RANDOM % 1000)):$img"
			fi
		done |
		sort -n | cut -d':' -f2- |
		while read -r img; do
			set -x
			swww img $SWWWARGS "$img"
			set +x
			break
		done

else
	while true; do
		find "$dir" |
			while read -r img; do
				if [ "$img" != "$dir" ]; then
					echo "$((RANDOM % 1000)):$img"
				fi
			done |
			sort -n | cut -d':' -f2- |
			while read -r img; do
				echo "$img"
				swww img $SWWWARGS "$img"
				sleep $INTERVAL
			done
	done
fi
