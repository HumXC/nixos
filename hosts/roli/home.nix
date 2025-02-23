{
  inputs,
  pkgs,
  ...
}: {
  imports = [../theme.nix];
  stylix.cursor.size = 34;
  aris = {
    hyprland = {
      enable = true;
      enableBlurAndOpacity = false;
      var = {
        BROWSER = "zen";
        AQ_NO_MODIFIERS = "1";
      };
    };
    zsh.enable = true;
    helix.enable = true;
    kitty.enable = true;
    fcitx5.enable = true;
    desktop = {
      enable = true;
      useNvidia = true;
      monitor = [
        {
          name = "HDMI-A-1";
          size = "1920x1080";
          rate = 100.09;
        }
      ];
      execOnce = ["aika-shell"];
    };
    daw.enable = true;
  };
  home = {
    stateVersion = "24.11";
    packages = with pkgs;
      [
        egl-wayland
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
      ]
      ++ (with pkgs.unstable; [
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
        kicad
        qq
        winetricks
        wineWowPackages.waylandFull
      ])
      ++ (with pkgs.nur.repos; [
        ])
      ++ [
        inputs.aika-shell.packages.${system}.aika-shell
        inputs.aika-shell.packages.${system}.astal
      ];
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
