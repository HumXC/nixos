{ config, pkgs, os, sops, ... }: {
  home = {
    username = "${os.userName}";
    homeDirectory = "/home/${os.userName}";
    packages = with pkgs; [
      nil # nix 的 lsp
      nixpkgs-fmt # nix 的格式化程序
      gcc
      ffmpeg
      p7zip
      cowsay
      file
      (writeShellScriptBin "python" ''
        export LD_LIBRARY_PATH=$NIX_LD_LIBRARY_PATH
        exec ${python3}/bin/python "$@"
      '')
      obs-studio

      go
      wails
      upx
      nodejs_20 # https://matthewrhone.dev/nixos-npm-globally
      corepack_20

      zig
      zls
      lldb
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
  programs.direnv = {
    enable = true;
    enableBashIntegration = true; # see note on other shells below
    nix-direnv.enable = true;
  };
  home.sessionVariables = {
    DIRENV_LOG_FORMAT = "";
  };
  services.nextcloud-client = {
    enable = true;
    startInBackground = true;
  };
  # systemd.user.targets.hyprland-session.Unit.Wants = [ "xdg-desktop-autostart.target" ];
}
