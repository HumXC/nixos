{ lib, config, pkgs, ... }:
let
  cfg = config.aris.modules.sddm;
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
      name =
        if theme.package != null && theme.name != ""
        then theme.name
        else getThemeName theme.package;
      package =
        if theme.config == ""
        then theme.package
        else
          patchThemePackage {
            inherit name config; package = theme.package;
          };
    in
    if theme.package == null
    then { name = ""; package = null; config = ""; }
    else { inherit name package config; };
  theme = initTheme cfg.theme;
  sysPkgs = [ cfg.cursor.package ] ++ lib.optionals (theme.package != null) [ theme.package ];
  isEnable = cfg.enable;
in
{
  config = lib.mkIf isEnable {
    environment.systemPackages = sysPkgs;
    services.xserver = {
      enable = true;
      # See: https://github.com/NixOS/nixpkgs/blob/nixos-23.11/nixos/modules/services/x11/xserver.nix#L718
      excludePackages = with pkgs; [
        xorg.xorgserver.out
        xorg.xrandr
        xorg.xrdb
        xorg.setxkbmap
        xorg.iceauth
        xorg.xlsclients
        xorg.xset
        xorg.xsetroot
        xorg.xinput
        xorg.xprop
        xorg.xauth
        xterm
        xdg-utils
        xorg.xf86inputevdev.out
        nixos-icons
      ];
    };
    services.xserver.displayManager.sddm = {
      enable = true;
      theme = theme.name;
      settings = {
        Theme = {
          CursorTheme = cfg.cursor.name;
          CursorSize = cfg.cursor.size;
        };
        X11.ServerArguments = "-nolisten tcp -dpi ${ builtins.toString (builtins.floor (builtins.mul  cfg.scaleFactor 100) )}";
        X11.EnableHiDPI = true;
        Wayland.EnableHiDPI = true;
      };
    };
    services.xserver.displayManager.setupCommands = "${pkgs.xorg.xsetroot}/bin/xsetroot -cursor_name left_ptr";
  };
}

