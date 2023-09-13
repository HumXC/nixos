{ config, lib, pkgs, os, ... }:
let 
  userName = os.userName;
  scale = os.desktop.scale;
in{
  home.packages = with pkgs; [
      hyprpicker
      # 解决部分窗口中，鼠标指针显示为 “X” 的情况
      # 在 hyprland 配置中 exec-once = xsetroot -cursor_name left_ptr
      xorg.xsetroot 
  ];

  # 自启动 hyprland
  programs.zsh.initExtra = ''
    if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
       exec  Hyprland
    fi
  '';

  xdg.configFile."hypr" = {
    source = ./hypr;
    recursive = true;   # 递归整个文件夹
    executable = true;  # 将其中所有文件添加「执行」权限
  };
  xdg.configFile."hypr/hyprland.conf".text = ''
    # 脚本目录
    $scripts = $HOME/.config/hypr/scripts
    $bin = $HOME/.config/hypr/scripts/bin

    monitor =,highrr,auto, ${scale}
    # 设置鼠标光标
    exec-once=hyprctl setcursor Fluent-cursors-dark 28
    env = GTK_THEME, Fluent-Dark
    env = LANG, zh_CN.UTF-8
    env = LC_CTYPE, zh_CN.UTF-8
    env = EDITOR, helix
    env = TERMINAL, kitty
    env = GTK_IM_MODULE, fcitx5
    env = QT_IM_MODULE, fcitx5
    env = XMODIFIERS, @im=fcitx5
    env = GLFW_IM_MODULE, ibus
    env = QT_QPA_PLATFORMTHEME, gtk3
    env = QT_SCALE_FACTOR, ${scale}
    env = MOZ_ENABLE_WAYLAND, 1
    env = SDL_VIDEODRIVER, wayland
    env = _JAVA_AWT_WM_NONREPARENTING, 1
    env = QT_QPA_PLATFORM, wayland
    env = QT_WAYLAND_DISABLE_WINDOWDECORATION, 1
    env = QT_AUTO_SCREEN_SCALE_FACTOR, ${scale}
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