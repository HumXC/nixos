{ config, lib, pkgs, ... }:
let 
  rofi_ = builtins.fetchGit {
    url = "https://github.com/adi1090x/rofi.git";
    rev = "5ff95e6855bb49d9cedeecbe86db8dfbbb8714df";
  };
in
{

  home.packages = with pkgs; [
      rofi
  ];
  # ./rofi 里存放的是存储库：https://github.com/adi1090x/rofi
  # 将由 hyprland 里面的脚本调用
  home.file.".config/rofi" = {
    source = rofi_;
    recursive = true;   # 递归整个文件夹
    executable = true;  # 将其中所有文件添加「执行」权限
  };
}