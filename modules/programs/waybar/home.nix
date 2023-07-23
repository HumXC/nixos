{ config, lib, pkgs, username, ... }:{
  home.packages = with pkgs; [
      waybar
  ];
  xdg.configFile."waybar" = {
    source = ./waybar;
    recursive = true;   # 递归整个文件夹
    executable = true;  # 将其中所有文件添加「执行」权限
  };
}