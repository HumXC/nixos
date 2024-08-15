#!/usr/bin/env bash
[ -n "$WAYLAND_DISPLAY" ] || exit 1
# AUDIO_DEV="$(LANG=C pactl list sources | grep 'Name.*output' | cut -d ' ' -f 2)"
AUDIO_DEV="alsa_output.pci-0000_10_00.6.analog-stereo.monitor"
FOLDER="$HOME/Videos/Recordings"
[ -d "$FOLDER" ] || mkdir -p "$FOLDER"

SCRIPT_NAME=wfrc
LOCK=/tmp/WFRCLOCK

if [ -f "$LOCK" ]; then
  kill -TERM $(cat "$LOCK")
  exit
fi

echo "$$" >"$LOCK"

kill_wfrc() {
  kill -TERM $wf_recorder_pid
  rm $LOCK
  file_size=$(stat -c%s "$FILE_NAME")
  human_readable_size=$(numfmt --to=iec-i --suffix=B "$file_size")
  end_time=$(date +%s)
  duration=$((end_time - start_time))
  minutes=$((duration / 60))
  seconds=$((duration % 60))
  resolution=$(echo $output | cut -d' ' -f2)
  if [ $minutes -gt 0 ]; then
    formatted_duration="${minutes}m ${seconds}s"
  else
    formatted_duration="${seconds}s"
  fi
  echo "file://$FILE_NAME" | wl-copy -t 'text/uri-list'
  notify-send --app-name=$SCRIPT_NAME 'Finished.' \
    "$formatted_duration | $human_readable_size | $resolution" --icon=record-screen-symbolic
  exit
}

trap 'kill_wfrc $$' SIGINT SIGTERM
output=$(slurp)
result=$?
if ! [ $result -eq 0 ]; then
  rm "$LOCK"
  exit
fi

notify-send --app-name=$SCRIPT_NAME 'Rec.' --icon=record-screen-symbolic

FILE_NAME="$FOLDER/$SCRIPT_NAME-$(date -u +%Y-%m-%dT%H-%M-%S).mp4"
wf-recorder -f $FILE_NAME -g "$output" --audio=$AUDIO_DEV &
start_time=$(date +%s)
wf_recorder_pid=$!

wait $wf_recorder_pid
