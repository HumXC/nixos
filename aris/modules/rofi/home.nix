{ config, lib, pkgs, getAris, ... }:
let
  isEnabled = (getAris config).modules.rofi.enable;
  src = builtins.fetchGit {
    url = "https://github.com/adi1090x/rofi.git";
    rev = "5ff95e6855bb49d9cedeecbe86db8dfbbb8714df";
  };
in
{
  config = lib.mkIf isEnabled {
    xdg.configFile."rofi" = {
      source = "${src}/files";
      recursive = true; # 递归整个文件夹
      executable = true; # 将其中所有文件添加「执行」权限
    };
    home.file.".local/share/fonts" = {
      source = src;
      recursive = true; # 递归整个文件夹
      executable = true; # 将其中所有文件添加「执行」权限
    };
    home.packages = with pkgs; [
      rofi-wayland
    ];
  };
}
