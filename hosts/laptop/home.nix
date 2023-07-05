{ config, lib, pkgs, username, ... }:
{
  imports = [ (import ../../modules/desktop/home.nix) ];
  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";
    packages = (with pkgs; [
      # go-cqhttp      
      
    ]) ++ (with config.nur.repos;[
      linyinfeng.clash-premium
    ]);
  };
  programs = {
    home-manager.enable = true;
    git = {
      enable = true;
      userName = "HumXC";
      userEmail = "Hum-XC@outlook.com";
      
    };
  };
  # systemd.user.targets.hyprland-session.Unit.Wants = [ "xdg-desktop-autostart.target" ];
  
  home.stateVersion = "22.11";
}