{ config, lib, pkgs, os, ... }:
let
  userName = os.userName;
  currentTheme = config.aris.desktop.currentTheme;
  scale = toString config.aris.desktop.theme.scaleFactor;
  cursorSize = toString config.aris.desktop.theme.cursorSize;
  execOnce = pkgs.lib.concatStrings (builtins.map (x: "exec-once = " + x + "\n") config.aris.desktop.execOnce);
  env = builtins.concatStringsSep "\n" (lib.attrValues (builtins.mapAttrs (k: v: "\$${k} = ${v}") os.programs.hyprland.env));
in
{
  home.packages = with pkgs;
    [
      hyprpicker
      swww
      # 剪贴板功能
      wl-clipboard
      cliphist
      wl-clip-persist
      # 截图功能
      grim
      slurp
      swappy
    ];

  xdg.configFile."hypr" = {
    source = ./hypr;
    recursive = true; # 递归整个文件夹
    executable = true; # 将其中所有文件添加「执行」权限
  };

  xdg.configFile."hypr/env.conf".text = ''${env}'';
  # BUG 如果 monitor scale 不为整数 并且使用支持的分数 例如 1.2 1.5
  # 会导致鼠标光标的大小在 waybar(gtk) 和 hyprland 之间变化
  xdg.configFile."hypr/hyprland.conf".text = ''
    source = ./env.conf
    # 脚本目录
    $scripts = $HOME/.config/hypr/scripts
    $bin = $HOME/.config/hypr/scripts/bin
    ${execOnce}
    monitor =, highrr, auto, ${scale}
    # 设置鼠标光标
    exec-once=hyprctl setcursor ${currentTheme.cursorTheme} ${cursorSize}

    env = LANG, zh_CN.UTF-8
    env = LC_CTYPE, zh_CN.UTF-8
    env = EDITOR, hx
    env = TERMINAL, kitty
    env = GTK_IM_MODULE, fcitx
    env = QT_IM_MODULE, fcitx
    env = XMODIFIERS, @im=fcitx
    env = GLFW_IM_MODULE, ibus
    env = QT_QPA_PLATFORMTHEME, gtk3
    env = MOZ_ENABLE_WAYLAND, 1
    env = SDL_VIDEODRIVER, wayland
    env = _JAVA_AWT_WM_NONREPARENTING, 1
    env = QT_QPA_PLATFORM, wayland
    env = QT_WAYLAND_DISABLE_WINDOWDECORATION, 1
    env = CLUTTER_BACKEND, wayland
    env = XDG_CURRENT_DESKTOP, Hyprland
    env = XDG_SESSION_DESKTOP, Hyprland
    env = XDG_SESSION_TYPE, wayland
    env = SDL_IM_MODULE, fcitx
    # 导入其他配置
    source = ./main.conf
    source = ./window-rule.conf
    source = ./binds.conf
  '';
}
