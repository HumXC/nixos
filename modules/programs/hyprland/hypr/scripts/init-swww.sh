#!/usr/bin/env bash
# 启动换壁纸脚本, 需要创建 $HOME/Pictures/wallpaper 文件夹，然后把壁纸放进去
dir=$(
    cd "$(dirname "$0")"
    pwd
)
while true; do
    swww init
    if [ $? -eq 0 ]; then
        break
    else
        swww kill
    fi
done
exec $dir/bin/swww-randomize.sh
