{ config, pkgs, lib, ... }:
let
  desktop = config.aris.desktop;
  scripts = "${config.home.homeDirectory}/.config/hypr/scripts";
  bin = "${scripts}/bin";

  monitor = map (m: "${m.name},${toString m.size}@${toString m.rate},auto,${toString m.scale}") desktop.monitor;
in
{
  # 脚本目录
  "$scripts" = scripts;
  "$bin" = bin;
  env = [
    "GLFW_IM_MODULE,ibus"
    "QT_QPA_PLATFORMTHEME,gtk3"
    "MOZ_ENABLE_WAYLAND,1"
    "SDL_VIDEODRIVER,wayland"
    "_JAVA_AWT_WM_NONREPARENTING,1"
    "QT_QPA_PLATFORM,wayland"
    "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
    "CLUTTER_BACKEND,wayland"
    "XDG_CURRENT_DESKTOP,Hyprland"
    "XDG_SESSION_DESKTOP,Hyprland"
    "XDG_SESSION_TYPE,wayland"
  ] ++ (if desktop.useNvidia then [
    "LIBVA_DRIVER_NAME,nvidia"
    "__GLX_VENDOR_LIBRARY_NAME,nvidia"
    "NVD_BACKEND,direct"
  ] else [ ]) ++ (if (desktop.theme.cursorTheme.name != "") then [
    "HYPRCURSOR_THEME,${desktop.theme.cursorTheme.name}"
    "HYPRCURSOR_SIZE,${builtins.toString desktop.theme.cursorTheme.size}"
  ] else [ ]);
  cursor.no_hardware_cursors = desktop.useNvidia;
  exec-once = desktop.execOnce ++ [
    # 解决部分窗口中，鼠标指针显示为 “X” 的情况 https://wiki.archlinuxcn.org/wiki/%E5%85%89%E6%A0%87%E4%B8%BB%E9%A2%98#%E6%9B%B4%E6%94%B9%E9%BB%98%E8%AE%A4_X_%E5%BD%A2%E5%85%89%E6%A0%87
    "${pkgs.xorg.xsetroot}/bin/xsetroot -cursor_name left_ptr"
    "${builtins.replaceStrings [ "\n" "\n\n"] [ ";" ";" ] config.xsession.initExtra}"
    # 启动剪贴板
    # https://wiki.hyprland.org/hyprland-wiki/pages/Useful-Utilities/Clipboard-Managers/
    "${pkgs.wl-clipboard}/bin/wl-paste --type text --watch cliphist store" #Stores only text data
    "${pkgs.wl-clipboard}/bin/wl-paste --type image --watch cliphist store" #Stores only image data
    "${pkgs.wl-clipboard}/bin/wl-clip-persist --clipboard both"
    # 启动 pot 翻译
    # https://github.com/Pylogmon/pot
  ] ++ (if (desktop.theme.cursorTheme.name != "") then [
    "hyprctl setcursor ${desktop.theme.cursorTheme.name} ${builtins.toString desktop.theme.cursorTheme.size}"
  ] else [ ]);
  monitor = monitor;
}
