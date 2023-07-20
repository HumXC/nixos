{ config, lib, pkgs, username, ... }:
let 
  themes = builtins.fetchGit {
    url = "https://github.com/dexpota/kitty-themes.git";
    rev = "b1abdd54ba655ef34f75a568d78625981bf1722c";
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