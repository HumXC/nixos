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
    services.gnome.gnome-keyring.enable = true;
    security.polkit.enable = true;
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
    fonts = {
      fontDir.enable = true;
      enableDefaultPackages = true;
      packages =
        (with pkgs; [
          (nerdfonts.override {fonts = ["FiraCode"];})
          twemoji-color-font
          babelstone-han
          misans
        ])
        ++ (with pkgs.nur.repos; [
          ]);
      fontconfig = {
        defaultFonts = {
          serif = ["MiSans" "FiraCode Nerd Font"];
          sansSerif = ["MiSans" "FiraCode Nerd Font"];
          monospace = ["MiSans" "FiraCode Nerd Font"];
          emoji = ["Twitter Color Emoji"];
        };
      };
    };
  };
}
