{ config, lib, pkgs, ... }:
let
  cfg = config.aris.helix;
  themes = builtins.fetchGit {
    url = "https://github.com/kovidgoyal/kitty-themes.git";
    rev = "46d9dfe230f315a6a0c62f4687f6b3da20fd05e4";
  };
in
{
  options.aris.kitty.enable = lib.mkEnableOption "helix";
  config = lib.mkIf cfg.enable {
    home.sessionVariables = {
      TERMINAL = "kitty";
    };
    home.packages = with pkgs; [
      kitty
    ];
    xdg.configFile."kitty/kitty.conf".source = ./kitty.conf;
    xdg.configFile."kitty/themes" = {
      source = themes.outPath + "/themes";
      recursive = true; # 递归整个文件夹
    };
  };
}
