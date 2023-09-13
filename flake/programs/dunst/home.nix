{ config, lib, pkgs, ... }:{
  home.packages = with pkgs; [
      dunst
  ];
  xdg.configFile."dunst/dunstrc".source = ./dunstrc;
}