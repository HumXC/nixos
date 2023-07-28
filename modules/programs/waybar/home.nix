{ config, lib, pkgs, username, waybarConfig, ... }:{
  home.packages = with pkgs; [
      waybar
  ];
  xdg.configFile."waybar" = {
    source = ./waybar;
    recursive = true;   # 递归整个文件夹
    executable = true;  # 将其中所有文件添加「执行」权限
  };

  # 复制自 config, 在 temperature#4 处的 hwmon-path 每台机器估计都不同
  # 需要外部传递
  xdg.configFile."waybar/config".text = ''
[
    {
        "name": "top-bar",
        "margin-top": 4,
        "margin-left": 4,
        "margin-right": 4,
        "height": 40,
        "layer": "top",
        "modules-left": [
            "tray",
            "network#2",
            "temperature#4"
        ],
        "modules-center": [
            "clock"
        ],
        "modules-right": [
            "backlight",
            "pulseaudio",
            "network",
            "battery"
        ],
        "network#2": {
            "interface": "wlp1s0",
            "interval": 3,
            "format": "  {bandwidthUpBytes}    {bandwidthDownBytes}"
        },
        "temperature#4": {
            "hwmon-path": ${waybarConfig.cpuTemperatureHwmonPath},
            "critical-threshold": 80,
            "interval": 3,
            "format-critical": "<span color=\"#fd5757\"> <b>{temperatureC}°C</b></span>",
            "format": "<b> {temperatureC}°C</b>"
        },
        "tray": {
            "icon-size": 18,
            "spacing": 10,
            "show-passive-items": true
        },
        "clock": {
            "format": "<b>{:%H:%M}</b>",
            "format-alt": "<b>{:%Y %m/%d %A}</b>",
            "tooltip-format": "<tt><small>{calendar}</small></tt>"
        },
        "backlight": {
            "tooltip": false,
            "format": " {}%",
            "interval": 1,
            "on-scroll-up": "light -A 1",
            "on-scroll-down": "light -U 1",
            "on-click": "light -A 20",
            "on-click-right": "light -U 20",
            "on-click-middle": "sh $HOME/.config/hypr/scripts/bin/swww-randomize.sh once"
        },
        "pulseaudio": {
            "tooltip": false,
            "scroll-step": 5,
            "format": "{icon} {volume}%",
            "format-muted": "{icon} {volume}%",
            "on-click-right": "pactl set-sink-mute @DEFAULT_SINK@ toggle",
            "on-click": "sh $HOME/.config/hypr/scripts/bin/app-switch.sh pavucontrol pavucontrol",
            "format-icons": {
                "default": [
                    "",
                    "",
                    ""
                ]
            },
            "ignored-sinks": [
                "Easy Effects Sink"
            ]
        },
        "network": {
            "tooltip": false,
            "format-wifi": "   {essid}",
            "format-ethernet": ""
        },
        "battery": {
            "full-at": 96,
            "states": {
                "good": 95,
                "warning": 30,
                "critical": 20
            },
            "format": "{icon}  {capacity}%",
            "format-charging": "  {capacity}%",
            "format-plugged": "  {capacity}%",
            "format-alt": "{time} {icon} ",
            "format-icons": [
                "",
                "",
                "",
                "",
                ""
            ]
        }
    },
    {
        "name": "disk",
        "margin-top": 156,
        "margin-left": 12,
        "height": 60,
        "layer": "bottom",
        "exclusive": false,
        "position": "top",
        "modules-left": [
            "custom/icon",
            "disk"
        ],
        "cpu": {
            "format": "{}"
        },
        "custom/icon": {
            "format": "󰋊",
            "tooltip": false
        }
    },
    {
        "name": "memory",
        "margin-top": 84,
        "margin-left": 12,
        "height": 60,
        "layer": "bottom",
        "exclusive": false,
        "position": "top",
        "modules-left": [
            "custom/icon",
            "memory"
        ],
        "memory": {
            "interval": 30,
            "format": "{used:0.2f}G / {total:0.1f}G"
        },
        "custom/icon": {
            "format": "󰘚",
            "tooltip": false
        }
    },
    {
        "name": "cpu",
        "margin-top": 12,
        "margin-left": 12,
        "height": 1,
        "width": 1,
        "layer": "bottom",
        "exclusive": false,
        "position": "top",
        "modules-left": [
            "custom/icon",
            "cpu"
        ],
        "cpu": {
            "format": "{avg_frequency}GHz | {usage}%"
        },
        "custom/icon": {
            "format": "󰍛",
            "tooltip": false
        }
    },
    {
        "name": "time",
        "margin-top": 50,
        "margin-right": 60,
        "layer": "bottom",
        "exclusive": false,
        "position": "right",
        "modules-left": [
            "clock#h",
            "clock#m"
        ],
        "clock#h": {
            "format": "<span face=\"MiSans\">{:%H}</span>",
            "tooltip-format": "<span size=\"x-large\">{:%m/%d %A}</span>"
        },
        "clock#m": {
            "format": "<span face=\"MiSans\">{:%M}</span>",
            "tooltip-format": "<span size=\"x-large\">{:%m/%d %A}</span>"
        }
    },
    {
        "name": "mpd-info",
        "margin-top": 430,
        "margin-right": 70,
        "width": 215,
        "layer": "bottom",
        "exclusive": false,
        "position": "right",
        "modules-left": [
            "mpd",
            "custom/fill"
        ],
        "mpd": {
            "interval": 10,
            "format-disconnected": "Disconnected",
            "format": "<b>{elapsedTime:%M:%S} / {totalTime:%M:%S}</b>",
            "on-click": "kitty -T ncmpcpp -e ncmpcpp"
        }
    },
    {
        "name": "mpd-control",
        "margin-top": 460,
        "margin-right": 70,
        "height": 60,
        "layer": "bottom",
        "exclusive": false,
        "position": "top",
        "modules-right": [
            "custom/prev",
            "custom/status",
            "custom/next"
        ],
        "custom/prev": {
            "format": "<span>󰙣</span>",
            "on-click": "mpc prev",
            "tooltip": false
        },
        "custom/next": {
            "format": "<span>󰙡</span>",
            "on-click": "mpc next",
            "tooltip": false
        },
        "custom/status": {
            "format": "{}",
            "exec": ".config/waybar/scripts/mpd.sh --status",
            "signal": 12,
            "interval": 10,
            "tooltip": false,
            "on-click": "mpc toggle; pkill -SIGRTMIN+12 waybar"
        }
    },
    {
        "name": "bottom-bar",
        "margin-bottom": 12,
        "layer": "bottom",
        "exclusive": false,
        "position": "bottom",
        "modules-center": [
            "wlr/taskbar"
        ],
        "wlr/taskbar": {
            "format": "{icon}",
            "icon-size": 43,
            "on-click": "activate",
            "on-click-middle": "close"
        }
    }
] 
  '';
}