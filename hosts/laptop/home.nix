{ config, lib, pkgs, username, ... }:{
  imports = [ (import ../../modules/desktop/home.nix) ];
  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";
    packages = (with pkgs; [
      direnv # 暂时不知道有什么用
      ffmpeg
      p7zip
      cowsay
      file
      python3
      obs-studio
    ]) ++ (with config.nur.repos;[
    
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