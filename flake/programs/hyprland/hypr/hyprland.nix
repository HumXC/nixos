{ config, pkgs, ... }:
let
  desktop = config.aris.desktop;
  currentTheme = desktop.currentTheme;
  scale = toString desktop.theme.scaleFactor;
  cursorSize = toString desktop.theme.cursorSize;
in
{
  # 脚本目录
  "$scripts" = "$HOME/.config/hypr/scripts";
  "$bin" = "$HOME/.config/hypr/scripts/bin";

  "$mod" = "SUPER";
  env = [
    "LANG, zh_CN.UTF-8"
    "LC_CTYPE, zh_CN.UTF-8"
    "EDITOR, hx"
    "TERMINAL, kitty"
    "GTK_IM_MODULE, fcitx"
    "QT_IM_MODULE, fcitx"
    "XMODIFIERS, @im=fcitx"
    "GLFW_IM_MODULE, ibus"
    "QT_QPA_PLATFORMTHEME, gtk3"
    "MOZ_ENABLE_WAYLAND, 1"
    "SDL_VIDEODRIVER, wayland"
    "_JAVA_AWT_WM_NONREPARENTING, 1"
    "QT_QPA_PLATFORM, wayland"
    "QT_WAYLAND_DISABLE_WINDOWDECORATION, 1"
    "CLUTTER_BACKEND, wayland"
    "XDG_CURRENT_DESKTOP, Hyprland"
    "XDG_SESSION_DESKTOP, Hyprland"
    "XDG_SESSION_TYPE, wayland"
    "SDL_IM_MODULE, fcitx"
  ];
  exec-once = desktop.execOnce ++ [
    "hyprctl setcursor ${currentTheme.cursorTheme} ${cursorSize}"
    # 启动剪贴板
    # https://wiki.hyprland.org/hyprland-wiki/pages/Useful-Utilities/Clipboard-Managers/
    "${pkgs.wl-clipboard}/bin/wl-paste --type text --watch cliphist store" #Stores only text data
    "${pkgs.wl-clipboard}/bin/wl-paste --type image --watch cliphist store" #Stores only image data
    "${pkgs.wl-clipboard}/bin/wl-clip-persist --clipboard both"
    # TODO: 迁移以下几项
    "$scripts/init-swww.sh"
    "fcitx5 -d"
    "easyeffects --gapplication-service"
    # 启动 pot 翻译
    # https://github.com/Pylogmon/pot
  ];
  monitor = ", highrr, auto, ${scale}";
}
