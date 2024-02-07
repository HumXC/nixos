{ config, lib, pkgs, os, ... }:
let
  userName = os.userName;
  scale = toString os.desktop.scaleFactor;
  cursorSize = toString os.desktop.cursorSize;
  initXsession = builtins.replaceStrings [ "\n" ] [ ";" ] config.xsession.initExtra;
  env = builtins.concatStringsSep "\n" (lib.attrValues (builtins.mapAttrs (k: v: "\$${k} = ${v}") os.programs.hyprland.env));
in
{
  home.packages = with pkgs;
    [
      hyprpicker
      # 解决部分窗口中，鼠标指针显示为 “X” 的情况
      # 在 hyprland 配置中 exec-once = xsetroot -cursor_name left_ptr
      xorg.xsetroot
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

  # 自启动 hyprland
  programs.zsh.initExtra = ''
    if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
       exec  Hyprland
    fi
  '';

  xdg.configFile."hypr" = {
    source = ./hypr;
    recursive = true; # 递归整个文件夹
    executable = true; # 将其中所有文件添加「执行」权限
  };

  # https://nixos.wiki/wiki/Sway
  # https://github.com/swaywm/sway/wiki/GTK-3-settings-on-Wayland
  xdg.configFile."hypr/scripts/configure-gtk.sh" = {
    text =
      let
        schema = pkgs.gsettings-desktop-schemas;
        datadir = "${schema}/share/gsettings-schemas/${schema.name}";
      in
      ''
        export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
        config="''${XDG_CONFIG_HOME:-$HOME/.config}/gtk-3.0/settings.ini"
        if [ ! -f "$config" ]; then exit 1; fi
        gnome_schema="org.gnome.desktop.interface"
        gtk_theme="$(grep 'gtk-theme-name' "$config" | sed 's/.*\s*=\s*//')"
        icon_theme="$(grep 'gtk-icon-theme-name' "$config" | sed 's/.*\s*=\s*//')"
        cursor_theme="$(grep 'gtk-cursor-theme-name' "$config" | sed 's/.*\s*=\s*//')"
        font_name="$(grep 'gtk-font-name' "$config" | sed 's/.*\s*=\s*//')"
        gsettings set "$gnome_schema" gtk-theme "$gtk_theme"
        gsettings set "$gnome_schema" icon-theme "$icon_theme"
        gsettings set "$gnome_schema" cursor-theme "$cursor_theme"
        gsettings set "$gnome_schema" font-name "$font_name"
      '';
    executable = true;
  };
  xdg.configFile."hypr/env.conf".text = ''${env}'';
  xdg.configFile."hypr/hyprland.conf".text = ''
    source = ./env.conf
    # 脚本目录
    $scripts = $HOME/.config/hypr/scripts
    $bin = $HOME/.config/hypr/scripts/bin

    # 初始化 xwayland 配置
    exec-once=${ initXsession }
    
    exec-once=swaync
    monitor =,highrr,auto,${scale}
    # 设置鼠标光标
    exec-once=hyprctl setcursor ${os.desktop.cursorTheme} ${cursorSize}
    env = XCURSOR_SIZE, ${cursorSize}
    # env = GDK_SCALE, ${scale}
    env = GTK_THEME, ${os.desktop.gtkTheme}
    env = LANG, zh_CN.UTF-8
    env = LC_CTYPE, zh_CN.UTF-8
    env = EDITOR, hx
    env = TERMINAL, kitty
    env = GTK_IM_MODULE, fcitx
    env = QT_IM_MODULE, fcitx
    env = XMODIFIERS, @im=fcitx
    env = GLFW_IM_MODULE, ibus
    env = QT_QPA_PLATFORMTHEME, gtk3
    # env = QT_SCALE_FACTOR, ${scale}
    env = MOZ_ENABLE_WAYLAND, 1
    env = SDL_VIDEODRIVER, wayland
    env = _JAVA_AWT_WM_NONREPARENTING, 1
    env = QT_QPA_PLATFORM, wayland
    env = QT_WAYLAND_DISABLE_WINDOWDECORATION, 1
    # env = QT_AUTO_SCREEN_SCALE_FACTOR, ${scale}
    # env = WLR_DRM_DEVICES, /dev/dri/card1:/dev/dri/card0;
    # env = WLR_NO_HARDWARE_CURSORS, 1; # if no cursor,uncomment this line
    # env = WLR_RENDERER_ALLOW_SOFTWARE, 1;
    # env = GBM_BACKEND, nvidia-drm;
    env = CLUTTER_BACKEND, wayland
    # env = __GLX_VENDOR_LIBRARY_NAME, nvidia;
    # env = LIBVA_DRIVER_NAME, nvidia;
    # env = WLR_RENDERER, vulkan;
    # env = __NV_PRIME_RENDER_OFFLOAD, 1;

    env = XDG_CURRENT_DESKTOP, Hyprland
    env = XDG_SESSION_DESKTOP, Hyprland
    env = XDG_SESSION_TYPE, wayland
    env = QT_STYLE_OVERRIDE, kvantum
    env = SDL_IM_MODULE, fcitx
    # 导入其他配置
    source = ./main.conf
    source = ./window-rule.conf
    source = ./binds.conf
  '';
}
