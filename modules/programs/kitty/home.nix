{ config, lib, pkgs, username, ... }:
let 
# TODO: 貌似不正确的使用
  themes = builtins.fetchGit {
    url = "https://github.com/kovidgoyal/kitty-themes.git";
    rev = "9a30b1b123c6d076aedcb1b6f1dbc55c35b4e5d1";
  };
in
{
  home.packages = with pkgs; [
      kitty
  ];
  home.file.".config/kitty" = {
    source = ./kitty;
    recursive = true;   # 递归整个文件夹
  };
  home.file.".config/kitty/themes" = {
    source = themes.outPath + "/themes";
    recursive = true;   # 递归整个文件夹
  };
}