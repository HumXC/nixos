#!/usr/bin/env sh
until swww query >/dev/null 2>&1; do
    :
done
