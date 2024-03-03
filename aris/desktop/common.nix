{ pkgs, lib, config, ... }:
let
  themes = lib.attrsets.mapAttrs (k: v: v.meta) (import ./themes { inherit config pkgs; });
in
{
  config = {
    aris.common.desktop.execOnce = with pkgs;[
      "${polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
    ];
    aris.common.desktop.themes = themes;
  };
}
