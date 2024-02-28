{ lib, pkgs, config, ... }: {
  desktop = {
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
    execOnce = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Execute commands once after the WM is initialized.";
    };
  };
}
