{ lib, config, importHm, pkgs, ... }:
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
    scaleFactor = lib.mkOption {
      type = lib.types.float;
      default = 1;
      description = "Scale factor.";
    };
    theme = lib.mkOption {
      type = lib.types.str;
      default = "Fluent-Dark";
      description = "select defined theme.";
    };
    cursorSize = lib.mkOption {
      type = lib.types.int;
      default = 28;
      description = "Cursor size.";
    };
    cursorTheme = lib.mkOption {
      type = lib.types.str;
      description = "Cursor Theme.";
    };
    gtkTheme = lib.mkOption {
      type = lib.types.str;
      description = "GTK Theme.";
    };
    iconTheme = lib.mkOption {
      type = lib.types.str;
      description = "Icon Theme.";
    };
  };

  config =
    let
      themeMappings = {
        Fluent-Dark = {
          home = ./theme/Fluent-dark.nix;
          gtk = "Fluent-Dark";
          icon = "Fluent-Dark";
          cursor = "Fluent-cursors-dark";
        };
      };
      currentTheme = themeMappings.${config.os.desktop.theme} or themeMappings.Fluent-Dark;
    in
    lib.mkIf config.os.desktop.enable
      {
        # 这三个值是预制的，不应该由外部修改
        os.desktop.gtkTheme = currentTheme.gtk;
        os.desktop.iconTheme = currentTheme.icon;
        os.desktop.cursorTheme = currentTheme.cursor;
        home-manager.users.${config.os.userName}.imports = [
          ./home.nix
          currentTheme.home
        ];
        services.gnome.gnome-keyring.enable = true; # vscode 依赖

        os.programs = setEnable [
          "dunst"
          "fcitx5"
          "helix"
          "hyprland"
          "kitty"
          # "lemurs"
          "mpd"
          "rofi"
          "waybar"
          "zsh"
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
      };

}
