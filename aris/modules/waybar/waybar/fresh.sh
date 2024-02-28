#!/usr/bin/env bash
while true; do
    killall -SIGUSR2 waybar
    sleep 5
done
