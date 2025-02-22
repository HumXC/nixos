{ pkgs, ... }: {
  aris = {
    helix.enable = true;
    zsh.enable = true;
    zsh.p10kType = "2";
  };
  home = {
    packages = with pkgs; [
      htop
      btop
      trashy
      go
    ];
  };
  programs.direnv = {
    enable = true;
    enableBashIntegration = true; # see note on other shells below
    nix-direnv.enable = true;
  };
  home.sessionVariables = {
    DIRENV_LOG_FORMAT = "";
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
