{ config, lib, pkgs, username, ... }:{
  home.packages = with pkgs; [
      hyprpicker
      # 解决部分窗口中，鼠标指针显示为 “X” 的情况
      # 在 hyprland 配置中 exec-once = xsetroot -cursor_name left_ptr
      xorg.xsetroot 
  ];
  xdg.configFile."hypr" = {
    source = ./hypr;
    recursive = true;   # 递归整个文件夹
    executable = true;  # 将其中所有文件添加「执行」权限
  };
  # 自启动 hyprland
  programs.zsh.initExtra = ''
    if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
       exec  Hyprland
    fi
  '';
}