{ config, lib, pkgs, username, ... }:{
  home.packages = with pkgs; [
      dunst
  ];
  xdg.configFile."dunst" = {
    source = ./dunst;
    recursive = true;   # 递归整个文件夹
    executable = true;  # 将其中所有文件添加「执行」权限
  };
}