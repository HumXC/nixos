{ config, lib, pkgs, username, ... }:{
  home.packages = with pkgs; [
      helix
    ];
  xdg.configFile."helix" = {
    source = ./helix;
    recursive = true;
  };
}