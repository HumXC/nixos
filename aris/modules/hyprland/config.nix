{ config, lib, ... }:
let
  allSession = map (c: c.desktop.session) (builtins.filter (v: v.desktop.enable) (builtins.attrValues config.aris.users));
  session = builtins.filter (s: s != { }) allSession;
in
{
  config.services.xserver.displayManager.session = session;
}
