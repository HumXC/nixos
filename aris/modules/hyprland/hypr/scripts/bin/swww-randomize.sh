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
if [ "$2" != "" ] && [ "$2" == "noargs" ]; then
	SWWWARGS=""
fi
export SWWW_TRANSITION_FPS=160
export SWWW_TRANSITION_STEP=160
# This controls (in seconds) when to switch to the next image
INTERVAL=120
ALLOWED_EXTENSIONS=("jpg" "jpeg" "png" "gif")
function is_allowed_extension() {
	local file="$1"
	local extension="${file##*.}"

	for allowed_ext in "${ALLOWED_EXTENSIONS[@]}"; do
		if [ "$allowed_ext" == "$extension" ]; then
			return 0 # Allowed extension
		fi
	done

	return 1 # Not allowed extension
}

function process_random_image() {
	local selected_img=""
	for ((i = 1; i <= 100; i++)); do
		find "$dir" |
			while read -r img; do
				if [ "$img" != "$dir" ]; then
					echo "$((RANDOM % 1000)):$img"
				fi
			done |
			sort -n | cut -d':' -f2- |
			while read -r img; do
				if is_allowed_extension "$img"; then
					selected_img="$img"
					echo "$selected_img"
					break
				fi
			done
		if [ "$selected_img"!="" ]; then
			break
			return 0
		fi
	done

	return 1
}
if [ "$1" == "once" ]; then
	selected_img=$(process_random_image)
	echo "$selected_img"
	$(swww img $SWWWARGS "$selected_img")
else
	while true; do
		selected_img=$(process_random_image)
		echo "$selected_img"
		$(swww img $SWWWARGS "$selected_img")
		sleep $INTERVAL
	done
fi
