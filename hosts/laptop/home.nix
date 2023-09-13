{ config, pkgs, os, ... }:{
  home = {
    username = "${os.userName}";
    homeDirectory = "/home/${os.userName}";
    packages = with pkgs; [
      direnv # 暂时不知道有什么用
      ffmpeg
      p7zip
      cowsay
      file
      python3
      obs-studio
    ];
  };
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userName = "HumXC";
    userEmail = "Hum-XC@outlook.com";
  };
  # systemd.user.targets.hyprland-session.Unit.Wants = [ "xdg-desktop-autostart.target" ];
}