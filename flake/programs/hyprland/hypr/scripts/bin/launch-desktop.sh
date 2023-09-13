#!/usr/bin/env bash

# 查找 $XDG_DATA_DIRS 内的 .desktop 文件，并启动
# 第一个参数是要查找的文件名，不包含 ".desktop" 后缀
# 例如要查找 "code.desktop" 则只需要输入 "code"。
# 第一个参数之后的参数将被传递给这个 .desktop，
# 例如 "launch-desktop code /etc/nixos"，这样 "/etc/nixos" 就会被传递给 code.desktop
# 依赖 glib 的 gio launch 命令
# 如果参数数量不为1，显示错误信息并退出
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 filename [other-args...]"
    exit 1
fi

filename="$1.desktop"
found=0

# 从$XDG_DATA_DIRS环境变量中获取目录列表
IFS=: # 设置内部字段分隔符为冒号
for dir in $XDG_DATA_DIRS; do
    # 递归地在目录中查找文件
    path=$(find "$dir" -name "$filename" 2>/dev/null)
    if [ ! -z "$path" ]; then
        gio launch "$path" "${@:2}"
        found=1
        break # 只输出第一个找到的文件的路径
    fi
done

# 如果没有在任何目录中找到文件，显示错误信息并退出
if [ "$found" -eq 0 ]; then
    echo "Error: $filename not found in any directory in \$XDG_DATA_DIRS."
    exit 2
fi
