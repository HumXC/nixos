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
    execOnce = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Execute commands once after the WM is initialized.";
    };
  };

  config = lib.mkIf config.os.desktop.enable {
    os.programs = setEnable [
      "fcitx5"
      "helix"
      "kitty"
      "rofi"
    ];
  };
}
