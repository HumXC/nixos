{ config, lib, pkgs, username, ... }:
{
  imports = [
    ./hyprland/home.nix
    ./waybar/home.nix
    ./dunst/home.nix
    ./rofi/home.nix
  ];
  home.packages = (with pkgs; [
      kitty
      vscode # 依赖 gnome-keyring 和 xdg-utils; 见 https://nixos.wiki/wiki/Visual_Studio_Code
      xdg-utils
      rnix-lsp # nix 的 lsp，vscode 的 nix 扩展依赖
      google-chrome
      qq
      netease-cloud-music-gtk
    ]) ++ (with config.nur.repos;[
      
    ]);
}