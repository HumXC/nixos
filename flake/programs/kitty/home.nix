{ config, lib, pkgs, ... }:
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
  xdg.configFile."kitty/kitty.conf".source = ./kitty.conf;
  xdg.configFile."kitty/themes" = {
    source = themes.outPath + "/themes";
    recursive = true; # 递归整个文件夹
  };
}
