{ lib, cfg, config, pkgs, ... }:
let
  desktop = config.os.desktop;
  getThemeName = package:
    if package == null then ""
    else
      (builtins.elemAt
        (builtins.attrNames (builtins.readDir "${package}/share/sddm/themes")) 0
      );

  patchThemePackage = theme: theme.package.overrideAttrs (old: {
    postInstall = theme.package.postInstall + ''
      cat >$out/share/sddm/themes/${theme.name}/theme.conf <<EOF${theme.config}EOF
    '';
  });

  initTheme = theme:
    let
      config = theme.config;
      name = if theme.package != null && theme.name != "" then theme.name else getThemeName theme.package;
      package = if theme.config == "" then theme.package else patchThemePackage { inherit name config; package = theme.package; };
    in
    if theme.package == null then { name = ""; package = null; config = ""; }
    else { inherit name package config; };
in
{
  options.os.programs.sddm.enable = lib.mkEnableOption "sddm";
  options.os.programs.sddm.theme = lib.mkOption {
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
  config =
    let
      theme = initTheme cfg.theme;
      sysPkgs = [ desktop.currentTheme.cursorThemePackage ] ++ lib.optionals (theme.package != null) [ theme.package ];
    in
    lib.mkIf cfg.enable {
      environment.systemPackages = sysPkgs;
      services.xserver.enable = true;
      services.xserver.displayManager.sddm = {
        enable = true;
        theme = theme.name;
        settings = {
          Theme = {
            CursorTheme = desktop.currentTheme.cursorTheme;
            CursorSize = desktop.theme.cursorSize;
          };
          X11.ServerArguments = "-nolisten tcp -dpi ${ builtins.toString (builtins.floor (builtins.mul desktop.theme.scaleFactor 100) )}";
          X11.EnableHiDPI = true;
          Wayland.EnableHiDPI = true;
        };
      };
    };
}
