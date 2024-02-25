#!/usr/bin/env bash

## Author : Aditya Shakya (adi1090x)
## Github : @adi1090x
#
## Rofi   : Power Menu
#
## Available Styles
#
## style-1   style-2   style-3   style-4   style-5

# Current Theme
# 基于 https://github.com/adi1090x/rofi/blob/master/files/powermenu/type-3/powermenu.sh
# 修改了原脚本以支持 hyprland
dir="$HOME/.config/rofi/powermenu/type-3"
theme='style-2'

# CMDs
uptime="$(uptime | awk -F 'up' '{print $2}' | awk -F ',' '{print $1}' | tr -d ' ')"
# host=$(hostname)

# Options
shutdown=''
reboot=''
lock=''
suspend=''
logout=''
yes=''
no=''

# Rofi CMD
rofi_cmd() {
    rofi -x11 -dmenu \
        -p "Uptime: $uptime" \
        -mesg "Uptime: $uptime" \
        -theme ${dir}/${theme}.rasi
}

# Confirmation CMD
confirm_cmd() {
    rofi -dmenu \
        -p 'Confirmation' \
        -mesg 'Are you Sure?' \
        -theme ${dir}/shared/confirm.rasi
}

# Ask for confirmation
confirm_exit() {
    echo -e "$yes\n$no" | confirm_cmd
}

# Pass variables to rofi dmenu
run_rofi() {
    echo -e "$lock\n$suspend\n$logout\n$reboot\n$shutdown" | rofi_cmd
}

# Execute Command
run_cmd() {
    selected="$(confirm_exit)"
    if [[ "$selected" == "$yes" ]]; then
        if [[ $1 == '--shutdown' ]]; then
            systemctl poweroff
        elif [[ $1 == '--reboot' ]]; then
            systemctl reboot
        elif [[ $1 == '--suspend' ]]; then
            mpc -q pause
            amixer set Master mute
            systemctl suspend
        elif [[ $1 == '--logout' ]]; then
            hyprctl dispatch exit
        fi
    else
        exit 0
    fi
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
$shutdown)
    run_cmd --shutdown
    ;;
$reboot)
    run_cmd --reboot
    ;;
$lock)
    swaylock
    ;;
$suspend)
    run_cmd --suspend
    ;;
$logout)
    run_cmd --logout
    ;;
esac
