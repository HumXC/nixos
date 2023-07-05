{ config, lib, pkgs, username, ... }:{

  home.file.".config/hypr" = {
    source = ./hypr;
    recursive = true;   # 递归整个文件夹
    executable = true;  # 将其中所有文件添加「执行」权限
  };
}