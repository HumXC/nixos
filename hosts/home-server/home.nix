{ config, pkgs, os, sops, ... }: {
  home = {
    username = "${os.userName}";
    homeDirectory = "/home/${os.userName}";
    packages = with pkgs; [
      p7zip
      cowsay
    ];
  };

  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userName = "HumXC";
    userEmail = "Hum-XC@outlook.com";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };
}
