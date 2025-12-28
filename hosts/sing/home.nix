{pkgs, ...}: {
  aris = {
    helix.enable = true;
    fish.enable = true;
  };
  home = {
    stateVersion = "25.11";
    packages = with pkgs; [
      htop
      btop
      trashy
      go
      python3
      android-tools
    ];
  };
  programs.direnv = {
    enable = true;
    enableBashIntegration = true; # see note on other shells below
    nix-direnv.enable = true;
    silent = true;
  };
  services.vscode-server.enable = true;
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "HumXC";
        email = "Hum-XC@outlook.com";
      };
      init.defaultBranch = "main";
      http.postBuffer = "524288000";
    };
  };
}
