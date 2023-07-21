{ config, lib, pkgs, username, ... }:{

  home.packages = with pkgs; [
      helix
    ];
  home.file.".config/helix" = {
    source = ./helix;
    recursive = true;
  };
}