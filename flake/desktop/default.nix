{ lib, config, importHm, pkgs, ... }@all:
let
  setEnable = arr: builtins.listToAttrs (map (name: { inherit name; value = { enable = true; }; }) arr);
in
{
  options.os.desktop = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable desktop.";
    };
    theme = lib.mkOption {
      description = "Theme configuration";
      default = {
        name = "Fluent-Dark";
        cursorSize = 24;
        scaleFactor = 1.0;
      };
      type = lib.types.submodule {
        options = {
          name = lib.mkOption {
            type = lib.types.str;
            default = "Fluent-Dark";
            description = "Select defined theme.";
          };
          cursorSize = lib.mkOption {
            type = lib.types.int;
            default = 24;
            description = "Cursor size.";
          };
          scaleFactor = lib.mkOption {
            type = lib.types.float;
            default = 1.0;
            description = "Scale factor.";
          };
        };
      };
    };
    currentTheme = lib.mkOption {
      default = {
        gtkTheme = "";
        gtkThemePackage = null;
        iconTheme = "";
        iconThemePackage = null;
        cursorTheme = "";
        cursorThemePackage = null;
      };
      description = "Current theme configuration, read only, don't modify this option.";
      type = lib.types.submodule {
        options = {
          gtkTheme = lib.mkOption {
            type = lib.types.str;
            default = "";
            description = "Current gtk theme.";
          };
          gtkThemePackage = lib.mkOption {
            type = lib.types.nullOr lib.types.package;
            default = pkgs.fluent-icon-theme;
            description = "Current gtk theme package.";
          };
          iconTheme = lib.mkOption {
            type = lib.types.str;
            default = "";
            description = "Current icon theme.";
          };
          iconThemePackage = lib.mkOption {
            type = lib.types.nullOr lib.types.package;
            default = pkgs.fluent-icon-theme;
            description = "Current icon theme package.";
          };
          cursorTheme = lib.mkOption {
            type = lib.types.str;
            default = "";
            description = "Current cursor theme.";
          };
          cursorThemePackage = lib.mkOption {
            type = lib.types.nullOr lib.types.package;
            default = config.nur.repos.humxc.fluent-cursors-theme;
            description = "Current cursor theme package.";
          };
        };
      };
    };
  };

  config =
    let
      themes = import ./themes { inherit config lib pkgs; } // all;
      currentTheme = themes."${config.os.desktop.theme.name}";
    in
    lib.mkIf config.os.desktop.enable {
      os.desktop.currentTheme = with currentTheme;{
        inherit
          gtkTheme gtkThemePackage
          iconTheme iconThemePackage
          cursorTheme cursorThemePackage;
      };
      home-manager.users.${config.os.userName}.imports = [
        ./home.nix
        currentTheme.home
      ];
      services.gnome.gnome-keyring.enable = true; # vscode 依赖
      os.programs = setEnable [
        "fcitx5"
        "helix"
        "hyprland"
        "kitty"
        "mpd"
        "rofi"
        "waybar"
        "zsh"
        "sddm"
      ];
      # TODO: Hyprland 不会有 graphical-session.target，需要想办法启动他
      # FIXME: 这个 service 没用
      systemd.user.services.polkit-gnome-authentication-agent-1 = {
        description = "polkit-gnome-authentication-agent-1";
        # wantedBy = [ "graphical-session.target" ];
        # wants = [ "graphical-session.target" ];
        # after = [ "graphical-session.target" ];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
      programs.light.enable = true; # 用于控制屏幕背光
      fonts = {
        fontDir.enable = true;
        enableDefaultPackages = true;
        packages = (with pkgs; [
          (nerdfonts.override { fonts = [ "FiraCode" ]; })
          twemoji-color-font
          babelstone-han
        ]) ++ (with config.nur.repos;[
          humxc.misans
        ]);
        fontconfig = {
          defaultFonts = {
            serif = [ "MiSans" "FiraCode Nerd Font" ];
            sansSerif = [ "MiSans" "FiraCode Nerd Font" ];
            monospace = [ "MiSans" "FiraCode Nerd Font" ];
            emoji = [ "Twitter Color Emoji" ];
          };
        };
      };
    };
}
