{ config, pkgs, sops, ... }: {
  home = {
    packages = with pkgs; [
      qq
      telegram-desktop
      krita
      mpv

      btop
      diskonaut
      trashy
      plex-media-player

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
      foliate

      go
      protobuf
      wails
      upx
      nodejs_20 # https://matthewrhone.dev/nixos-npm-globally
      corepack_20

      zig
      zls
      lldb
    ];
    file.".gitconfig" = {
      force = true;
      text = ''
        [safe]
        	directory = /etc/nixos
        [credential "https://github.com"]
        	helper = !${pkgs.gh}/bin/gh auth git-credential
        [credential "https://gist.github.com"]
        	helper = !${pkgs.gh}/bin/gh auth git-credential      
      '';
    };
  };

  programs.zsh.initExtraBeforeCompInit = ''
    export PATH=$HOME/.npm-packages/bin:$PATH
    export NODE_PATH=~/.npm-packages/lib/node_modules
    export PNPM_HOME=~/.npm-packages/pnpm
    export PATH=$PNPM_HOME:$PATH
  '';

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
}
