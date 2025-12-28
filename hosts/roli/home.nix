{
  inputs,
  pkgs,
  ...
}: {
  imports = [../theme.nix];
  aris = {
    hyprland = {
      enable = true;
      enableBlurAndOpacity = false;
      var = {
        BROWSER = "zen";
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
    stateVersion = "25.11";
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

        btop
        trashy

        p7zip
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

        godot_4
        kicad
        qq
        winetricks
        wineWowPackages.waylandFull
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
    settings = {
      user = {
        name = "HumXC";
        email = "Hum-XC@outlook.com";
      };
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
