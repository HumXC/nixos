{ pkgs, inputs, ... }: {
  imports = [ ../theme.nix ];
  stylix.cursor.size = 34;
  aris = {
    hyprland = {
      enable = true;
      var = {
        BROWSER = "zen";
      };
    };
    mpd = {
      enable = true;
      musicDirectory = "/disk/files/HumXC/Music";
    };
    zsh.enable = true;
    helix.enable = true;
    kitty.enable = true;
    fcitx5.enable = true;
    daw.enable = true;
    desktop = {
      enable = true;
      x11Scale = 1.25;
      monitor = [{
        name = "DP-2";
        size = "2560x1440";
        rate = 180.0;
        scale = 1.25;
      }];
      execOnce = [ "aika-shell" ];
    };
  };

  home = {
    stateVersion = "24.11"; # TODO: remove this
    packages = with pkgs; [
      sassc
      ddcutil
      bun
      mpv
      swayimg
      krita
      go-musicfox
      obsidian

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
      blender
      obs-studio
    ] ++ (with pkgs.unstable;[
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

      godot_4
    ]) ++ (with pkgs.nur.repos;[
      humxc.qq
    ]) ++ [
      inputs.aika-shell.packages.${system}.aika-shell
      inputs.aika-shell.packages.${system}.astal
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
}
