{ config, pkgs, pkgs-unstable, ... }: {
  home = {
    packages = with pkgs; [
      mpv
      krita

      zoxide
      btop
      diskonaut
      trashy

      gcc
      ffmpeg
      p7zip
      cowsay
      file
      (writeShellScriptBin "python" ''
        export LD_LIBRARY_PATH=$NIX_LD_LIBRARY_PATH
        exec ${python3}/bin/python "$@"
      '')
      foliate
      obs-studio
    ] ++ (with pkgs-unstable;[
      vscode
      qq
      telegram-desktop

      go
      protobuf
      wails
      upx
      nodejs_20 # https://matthewrhone.dev/nixos-npm-globally
      corepack_20

      zig
      zls
      lldb
      gdb

      blender
      godot_4
    ]) ++ (with config.nur.repos;[
      ruixi-rebirth.go-musicfox
      humxc.hmcl-bin
    ]);
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
    eval "$(zoxide init zsh)"
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
      http.postBuffer = "524288000";
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
  programs.ags = {
    enable = true;
    extraPackages = with pkgs; [
      glib
      gtksourceview
      webkitgtk
      accountsservice
    ];
  };
}
