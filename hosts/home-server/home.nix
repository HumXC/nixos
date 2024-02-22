{ config, pkgs, os, sops, ... }: {
  home = {
    username = "${os.userName}";
    homeDirectory = "/home/${os.userName}";
    packages = with pkgs; [
      htop
      btop
      diskonaut
      trashy
      nil # nix 的 lsp
      nixpkgs-fmt # nix 的格式化程序
      go
      gh
    ];
  };
  services.vscode-server.enable = true;
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
