{ lib, ... }:
let
  mod = "SUPER";
  bind = key1: key2: action: arg:
    "${key1},${key2},${action}" +
    "${lib.optionalString (arg != "") ",${arg}"}";
  exec = key1: key2: arg: bind key1 key2 "exec" arg;
  modWith = key2: action: arg: bind "${mod}" key2 action arg;
  execModWith = key2: arg: modWith key2 "exec" arg;
  workspaceWithNumber = key: builtins.concatLists (map
    (n: [
      "${key},${n},workspace,${if (n=="0") then "10" else n}"
      "${key}_CTRL,${n},movetoworkspace,${if (n=="0") then "10" else n}"
    ]) [ "1" "2" "3" "4" "5" "6" "7" "8" "9" "0" ]);

  # rofi启动器名称：https://github.com/adi1090x/rofi
  rofiLauncherType = "type-3";
  rofiLauncherStyle = "style-3";
in
{
  bind = (workspaceWithNumber "${mod}") ++ [
    "super, o, exit"
    # 颜色选择
    # (execModWith "P" "hyprpicker -a")
    # 隐藏/显示 right-bar
    (execModWith "Q" ''ags -r "toggle_right_bar()"'')
    # 打开vscode
    (execModWith "C" "$bin/launch-desktop.sh $EDITOR")
    # 打开浏览器
    (execModWith "B" "$bin/launch-desktop.sh $BROWSER")
    # 打开终端
    (exec "SHIFT" "RETURN" "$bin/launch-desktop.sh kitty")
    # 启动资源管理器
    (execModWith "E" "nautilus")
    # 更改浮动状态
    (modWith "SHIFT_R" "togglefloating" "")
    # 固定浮动窗口
    (modWith "P" "pin" "")
    # 关闭活动2
    "${mod}_BackSpace,BackSpace,killactive"
    "Alt_Q,Q,killactive"
    # 打开程序启动器
    (execModWith "TAB" "$bin/app-switch.sh '$bin/rofi.sh ${rofiLauncherType} ${rofiLauncherStyle} drun' rofi")

    # 选择区域截图打开 swappy 编辑后写入剪贴板
    # 需要安装 swappy, grim, wl-clipborad,slurp
    # 每次截图都会保存到 Picture/screenshot
    # 直接截图复制到剪贴板而不编辑
    (execModWith "S" "$bin/screenshot.sh")
    (exec "${mod}_CTRL" "S" "$bin/screenshot.sh noedit copy-name")
    # 截图后打开 swappy 编辑图片
    (exec "${mod}_SHIFT" "S" "$bin/screenshot.sh edit")
    (exec "${mod}_SHIFT_CTRL" "S" "$bin/screenshot.sh edit copy-name")
    # 录制屏幕
    (execModWith "R" "ags request recorder")
    # 显示剪贴板历史
    # fcitx5 自带这个功能，默认触发键是 ctrl+; 可以在 fcitx5配置 中的 [附加组件] 里关闭
    (execModWith "V" "ags request clipboard")
    # 登出界面
    (exec "CONTROL_ALT" "DELETE" "ags request powermenu")
    (execModWith "L" "ags request lockscreen")

    # 切换桌面
    "SHIFT_${mod},left,workspace,-1"
    "SHIFT_${mod},right,workspace,+1"
    "SHIFT_${mod},H,workspace,-1"
    "SHIFT_${mod},L,workspace,+1"

    # 切换窗口焦点
    "${mod},left,movefocus,l"
    "${mod},right,movefocus,r"
    "${mod},up,movefocus,u"
    "${mod},down,movefocus,d"

    "${mod},H,movefocus,l"
    "${mod},L,movefocus,r"
    "${mod},K,movefocus,u"
    "${mod},J,movefocus,d"

    # 移动窗口
    "${mod}_CONTROL,left,movewindow,l"
    "${mod}_CONTROL,right,movewindow,r"
    "${mod}_CONTROL,up,movewindow,u"
    "${mod}_CONTROL,down,movewindow,d"

    # 全屏
    "${mod},RETURN,fullscreen,1"
    "${mod}_SHIFT,RETURN,fullscreen"

    "${mod},mouse_down,workspace,e+1"
    "${mod},mouse_up,workspace,e-1"
  ];

  # 调整窗口大小
  binde = [
    "${mod}_ALT,right,resizeactive,60 0"
    "${mod}_ALT,left,resizeactive,-60 0"
    "${mod}_ALT,up,resizeactive,0 -60"
    "${mod}_ALT,down,resizeactive,0 60"
  ];
  bindm = [
    "${mod},mouse:272,movewindow"
    "${mod},mouse:273,resizewindow"
  ];

}
