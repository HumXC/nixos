#!/usr/bin/env bash
DIR="$HOME/Pictures/screenshot"
if [ ! -d "$DIR" ]; then
    mkdir -p "$DIR"
fi
file=$HOME/Pictures/screenshot/$(date "+%F-%T").png
region=$(slurp 2>&1)
img=""
# 检查 region 的值
if [ "$region" != "selection cancelled" ]; then
    # 如果选择不是被取消的，则使用 grim 截图
    # 如果第一个参数的值是“edit”，则调用 swappy
    if [ "$1" == "edit" ]; then
        if [ "$2" == "copy-name" ]; then
            grim -g "$region" - | swappy -f - -o "$file"
            wl-copy "$file"
        else
            grim -g "$region" - | swappy -f - -o - | tee "$file" | wl-copy -t image/png
        fi
    else
        if [ "$2" == "copy-name" ]; then
            grim -g "$region" "$file"
            wl-copy "$file"
        else
            grim -g "$region" - | tee "$file" | wl-copy -t image/png
        fi
    fi
fi
