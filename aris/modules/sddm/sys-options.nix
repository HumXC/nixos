{ lib, pkgs, ... }: {
  options.aris.modules.sddm = {
    enable = lib.mkEnableOption "sddm";
    scaleFactor = lib.mkOption {
      type = lib.types.float;
      default = 1.0;
      description = "Scale factor for the theme";
    };
    theme = lib.mkOption {
      description = "Theme to use for SDDM";
      default = {
        name = "";
        package = null;
        config = "";
      };
      type = lib.types.submodule {
        options = {
          name = lib.mkOption {
            type = lib.types.str;
            default = "";
            description = "Name of the theme";
          };
          package = lib.mkOption {
            type = lib.types.nullOr lib.types.package;
            default = null;
            description = "Theme package to install";
          };
          config = lib.mkOption {
            type = lib.types.str;
            default = "";
            description = "Write to theme.conf file";
          };

        };
      };
    };
    cursor = lib.mkOption {
      default = {
        name = "Adwaita";
        package = pkgs.gnome.adwaita-icon-theme;
        size = 24;
      };
      type = lib.types.submodule {
        options = {
          name = lib.mkOption {
            type = lib.types.str;
            default = "Adwaita";
            description = "Cursor theme to use";
          };
          package = lib.mkOption {
            type = lib.types.package;
            default = pkgs.gnome.adwaita-icon-theme;
            description = "Cursor theme package to install";
          };
          size = lib.mkOption {
            type = lib.types.int;
            default = 24;
            description = "Cursor size";
          };
        };
      };
    };
  };

}
