{ lib, pkgs, config, name, ... }:
let
  themes = lib.attrsets.mapAttrs (k: v: v.meta) (import ./themes { inherit config pkgs; });
  meta = themes."${config.aris.users."${name}".desktop.theme.name}";
in
{
  options.desktop = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable desktop.";
    };
    useNvidia = lib.mkEnableOption "useNvidia";
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
          meta = lib.mkOption {
            type = lib.types.attrs;
            default = { };
            description = "Theme meta data, readonly.";
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
    monitor = lib.mkOption {
      type = lib.types.listOf (lib.types.submodule {
        options = {
          name = lib.mkOption {
            type = lib.types.str;
            description = "Like HDMI-A-1, eDP-1.";
          };
          size = lib.mkOption {
            type = lib.types.str;
            default = "1920x1080";
            description = "Monitor resolution, like 1920x1080.";
          };
          rate = lib.mkOption {
            type = lib.types.float;
            default = 60;
            description = "Refresh rate.";
          };
          scale = lib.mkOption {
            type = lib.types.float;
            default = 1.0;
            description = "Scale factor.";
          };
        };
      });
      default = [ ];
      description = "Monitor configuration list";
    };
    execOnce = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Execute commands once after the WM is initialized.";
    };
    # FIXME
    env = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      description = "env.";
    };
  };
  config.desktop.theme.meta = meta;
}
