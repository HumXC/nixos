{ lib, ... }:
let
  rule = name: class: title:
    "${name}" +
    "${lib.optionalString (class!="") ", class:${class}"}" +
    "${lib.optionalString (title!="") ", title:${title}"}";

  float = class: title: rule "float" class title;
  floatClass = class: float class "";
  floatTitle = title: float "" title;

  size = width: height: class: title:
    rule "size ${toString width} ${toString height}" class title;
  sizeClass = width: height: class: size width height class "";
  sizeTitle = width: height: title: size width height "" title;

  dimaround = class: title: rule "dimaround " class title;
  dimaroundClass = class: dimaround class "";
  dimaroundTitle = title: dimaround "" title;

  forceinput = class: title: rule "forceinput" class title;
  forceinputClass = class: forceinput class "";
  forceinputTitle = title: forceinput "" title;

  center = class: title: rule "center" class title;
  centerClass = class: center class "";
  centerTitle = title: center "" title;

  pin = class: title: rule "pin" class title;
  pinClass = class: pin class "";
  pinTitle = title: pin "" title;

  fullscreen = class: title: rule "fullscreen" class title;
  fullscreenClass = class: fullscreen class "";
  fullscreenTitle = title: fullscreen "" title;

  tile = class: title: rule "tile" class title;
  tileClass = class: tile class "";
  tileTitle = title: tile "" title;

  opacity = value: class: title: rule "opacity ${value}" class title;
  opacityClass = value: class: opacity value class "";
  opacityTitle = value: title: opacity value "" title;

in
{
  windowrulev2 = [
    # 杂项
    (opacity "0.98 override 0.96 override" ".+" "")
    (size 950 600 "brave" "保存文件")
    (floatClass "myproject")
    (floatClass "org.kde.polkit-kde-authentication-agent-1")
    (dimaroundClass "org.kde.polkit-gnome-authentication-agent-1")
    (floatClass "nm-connection-editor")
    (floatClass "pavucontrol")
    (floatClass "blueman-manager")
    (floatClass "Microsoft-edge")
    (floatClass "vlc")
    (floatClass "ncmpcpp")
    (sizeClass 300 300 "mpv")
    (dimaroundTitle "Authenticate")
    (forceinputTitle "Authenticate")
    (tileClass "Microsoft-edge")
    (dimaround "org.gnome.Nautilus" "无法访问位置")
    (dimaroundClass "gcr-prompter")
    # qq
    (float "QQ" "图片查看器")
    (float "QQ" "群聊的聊天记录")
    (float "QQ" "视频播放器")
    (fullscreen "QQ" "图片查看器")
    (fullscreen "QQ" "群聊的聊天记录")
    (fullscreen "QQ" "视频播放器")
    # Rofi
    (floatTitle "^(rofi - dmenu)|(rofi - )$")
    (dimaroundTitle "^(rofi - dmenu)|(rofi - )$")
    (pinTitle "^(rofi - dmenu)$")
    (sizeTitle 800 600 "^(rofi - dmenu)$")
    (fullscreenTitle "^(rofi - )|(rofi - Uptime:.+)$")
    # Wine
    (tileClass "explorer.exe")
    (fullscreenClass "fl64.exe")
    (sizeTitle 800 800 "Wine 设置")
    (tileClass "fl64.exe")
    # pot
    (floatClass "Pot")
    (pinClass "Pot")
    # UPBGE
    (float "Blender" "[UPBGE]")
    # WPS-Office
    (tileClass "^(wps)|(et)|(wpp)|(pdf)$")
    (floatTitle "^(wps)|(et)|(wpp)|(pdf)$")
    # vscode
    (center "Code" "^(打开文件夹)|(打开文件)$")
    (dimaround "Code" "^(打开文件夹)|(打开文件)$")
    # Telegram
    (float "org.telegram.desktop" "^(.*)(媒体查看器)$")
    (fullscreen "org.telegram.desktop" "^(.*)(媒体查看器)$")
    (opacity "1.0 override 1.0 override" "org.telegram.desktop" "^(.*)(媒体查看器)$")
    # jetbrains
    # (tileClass "jetbrains-studio")
    "noborder, class:^(jetbrains-)(.*)$"
    "windowdance,class:^(jetbrains-.*)$"
    "opacity 1 override 1 override,class:^(jetbrains-.*)$"
    "dimaround,class:^(jetbrains-.*)$,floating:1,title:^(?!win)"
    "center,class:^(jetbrains-.*)$,floating:1,title:^(?!win)"
    "noanim,class:^(jetbrains-.*)$,title:^(win.*)$"
    "noinitialfocus,class:^(jetbrains-.*)$,title:^(win.*)$"
    "rounding 0,class:^(jetbrains-.*)$,title:^(win.*)$"
    (float "^(jetbrains-.*)$" "^(win.*)$")
    # kdeconnect
    (floatClass "org.kde.kdeconnect.handler")
    # waydroid
    (fullscreen " Waydroid" "Waydroid")
  ];
}












