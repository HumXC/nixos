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
    waydroid.enable = true;
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
      execOnce = ["aika-shell"];
    };
  };

  home = {
    stateVersion = "24.11"; # TODO: remove this
    packages = with pkgs;
      [
        mpv
        swayimg
        krita
        go-musicfox

        btop
        trashy
        chromium
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
        qq
      ]
      ++ (with pkgs.unstable; [
        telegram-desktop
        godot_4
      ])
      ++ [
        inputs.aika-shell.packages.${system}.aika-shell
        inputs.aika-shell.packages.${system}.astal
        ddcutil
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
    silent = true;
  };
  services.nextcloud-client = {
    enable = true;
    startInBackground = true;
  };
}
