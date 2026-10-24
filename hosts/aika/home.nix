{
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [../theme.nix];
  aris = {
    hyprland.enable = true;
    mpd = {
      enable = true;
      musicDirectory = "/disk/files/HumXC/Music";
    };
    fish.enable = true;
    helix.enable = true;
    ghostty.enable = true;
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
        "noctalia"
        "QT_SCALE_FACTOR=0.8 flameshot"
        "xppen /mini"
      ];
    };
  };
  home.sessionVariables = {
    BROWSER = "zen-beta";
    TERMINAL = "ghostty"; # mika-shell uses this
    ONNXRUNTIME_NODE_INSTALL = "skip";
  };
  home = {
    stateVersion = "25.11"; # TODO: remove this
    packages = with pkgs;
      [
        btop
        trashy
        gcc
        gnumake
        cmake
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

        aria2
        lightpanda
        bottles
        xppen
      ]
      ++ (with pkgs.unstable; [
        telegram-desktop
        godot_4
        gdscript-formatter
        orca-slicer
        mpv
        swayimg
        krita
        go-musicfox
        (qq.override {
          commandLineArgs = "--ozone-platform=wayland --enable-wayland-ime --wayland-text-input-version=3 --disable-gpu";
        })
        obsidian
        agent-browser
        bun
        nodejs
        uv
        (spec-kit.overrideAttrs (_: {
          version = "1.0.4";
          src = fetchFromGitHub {
            owner = "github";
            repo = "spec-kit";
            tag = "v1.0.4";
            hash = "sha256-Dt4mZjgT5X86QnfggRB5sUuOFEb+SpDUiXPo/FTFmK4=";
          };
        }))
        noctalia
        pixelorama
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

        wlvncc

        # pi agent sandbox
        ripgrep
        bubblewrap
        socat
        kicad
        flameshot

        blender
      ];
  };
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      init.defaultBranch = "main";
      http.postBuffer = "524288000";
      safe.directory = lib.mkForce ["/disk/data/*" "/etc/nixos"];
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
  systemd.user.services.deepseek-harness = {
    Unit = {
      Description = "DeepSeek Harness web server";
      After = ["network.target"];
    };

    Service = {
      Type = "exec";
      WorkingDirectory = "%h";

      ExecStart = "${pkgs.bash}/bin/bash %h/.local/bin/dsh web --no-open";

      Environment = [
        "PATH=%h/.local/share/dsh-node/runtime/bin:%h/.npm-packages/bin:/run/current-system/sw/bin"
        "NPM_CONFIG_PREFIX=%h/.npm-packages"
      ];
    };

    Install = {
      WantedBy = ["default.target"];
    };
  };
}
