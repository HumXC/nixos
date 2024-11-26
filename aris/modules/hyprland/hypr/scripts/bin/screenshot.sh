#!/usr/bin/env bash
DIR="$HOME/Pictures/screenshot"
if [ ! -d "$DIR" ]; then
    mkdir -p "$DIR"
fi
# ags request "screenmask -l 0 - | swappy  -f - -o -"
file=$HOME/Pictures/screenshot/$(date "+%F-%T").png
img=""
# 如果选择不是被取消的，则使用 grim 截图
# 如果第一个参数的值是“edit”，则调用 swappy
if [ "$1" == "edit" ]; then
    if [ "$2" == "copy-name" ]; then
        result=$(ags request "screenshot \"$file\"")
        if [ "$result" == "" ]; then
            swappy -f \"$file\" -o \"$file\" && wl-copy \"$file\"
        fi
    else
        result=$(ags request "screenshot \"$file\"")
        if [ "$result" == "" ]; then
            swappy -f \"$file\" -o - | tee \"$file\" | wl-copy -t image/png
        fi
    fi
else
    if [ "$2" == "copy-name" ]; then
        result=$(ags request "screenshot $file")
        if [ "$result" == "" ]; then
            wl-copy \"$file\"
        fi
    else
        result=$(ags request "screenshot \"$file\"")
        if [ "$result" == "" ]; then
            cat $file | wl-copy -t image/png
        fi
    fi
fi
