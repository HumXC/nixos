{ lib, pkgs, config, ... }:
let
  execOnce = with pkgs;[
    "${polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
    "${swaynotificationcenter}/bin/swaync"
    "${waybar}/bin/waybar"
  ];
in
{
  config.aris.common.desktop.execOnce = execOnce;
}
