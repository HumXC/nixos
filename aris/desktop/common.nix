{ pkgs, lib, config, ... }:
let
  themes = lib.attrsets.mapAttrs (k: v: v.meta) (import ./themes { inherit config pkgs; });
in
{
  config = {
    aris.common.desktop.execOnce = with pkgs;[
      "${polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
      "${swaynotificationcenter}/bin/swaync"
      "${waybar}/bin/waybar"
    ];
    aris.common.desktop.themes = themes;
  };
}
