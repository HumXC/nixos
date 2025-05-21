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
    systemd.user.services.polkit-gnome-authentication-agent-1 = {
      enable = true;
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = ["graphical-session.target"];
      wants = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
}
