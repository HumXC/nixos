{
  pkgs,
  inputs,
  ...
}: {
  imports = [../theme.nix];
  aris = {
    hyprland = {
      enable = true;
      var = {
        BROWSER = "zen-beta";
      };
    };
    mpd = {
      enable = true;
      musicDirectory = "/disk/files/HumXC/Music";
    };
    fish.enable = true;
    helix.enable = true;
    kitty.enable = true;
    fcitx5.enable = true;
    daw.enable = true;
    desktop = {
      enable = true;
      x11Scale = 1.25;
      monitor = [
        {
          name = "DP-2";
          size = "2560x1440";
          rate = 180.0;
          scale = 1.25;
        }
      ];
      execOnce = [
        "mika-shell daemon > /tmp/mika-shell.log 2>&1"
      ];
    };
  };
  home.sessionVariables = {
    TERMINAL = "kitty"; # mika-shell uses this
  };
  home = {
    stateVersion = "25.11"; # TODO: remove this
    packages = with pkgs;
      [
        btop
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

        pavucontrol
        lark

        aria2
      ]
      ++ (with pkgs.unstable; [
        telegram-desktop
        godot_4
        hmcl
        blender
        orca-slicer
        mpv
        swayimg
        krita
        go-musicfox
        # (qq.override {
        #   commandLineArgs = "--ozone-platform=wayland --enable-wayland-ime --wayland-text-input-version=3 --disable-gpu";
        # })
        qq
        obsidian
      ])
      ++ [
        inputs.mika-shell.packages.${system}.debug
        wtype
        ddcutil
        grim

        scrcpy
        android-tools
        chromium

        inputs.comfyui.packages.${system}.default

        bun
        nodejs
        bruno
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
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      obs-backgroundremoval
      obs-pipewire-audio-capture
      obs-gstreamer
      obs-vkcapture
    ];
  };
  programs.direnv = {
    enable = true;
    enableBashIntegration = true; # see note on other shells below
    nix-direnv.enable = true;
    silent = true;
  };
  services.nextcloud-client = {
    enable = true;
    startInBackground = true;
  };
}
