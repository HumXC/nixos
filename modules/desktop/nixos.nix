{
  lib,
  config,
  pkgs,
  ...
}: let
  isEnabled =
    builtins.elem true
    (map
      (hm: hm.aris.desktop.enable)
      (builtins.attrValues config.home-manager.users));
in {
  config = lib.mkIf isEnabled {
    services.dbus = {
      enable = true;
      packages = [pkgs.gcr];
    };
    systemd.services.NetworkManager-wait-online.enable = false;
    services.gnome.gnome-keyring.enable = true;
    security.polkit.enable = true;
    services.gvfs.enable = true;
  };
}
