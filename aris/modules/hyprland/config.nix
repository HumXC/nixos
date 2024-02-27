{ config, lib, ... }:
let
  baseSessions = map (c: c.aris.desktop.session) (builtins.filter (v: v.aris.desktop.enable) (builtins.attrValues config.home-manager.users));
  filteredSession = builtins.filter (s: s != { }) baseSessions;
  session = map (s: with s;{ inherit manage name start; }) filteredSession;
  packages = map (s: s.package) filteredSession;
in
{
  config.services.xserver.displayManager.sessionPackages = packages;
  config.services.xserver.displayManager.session = session;
}
