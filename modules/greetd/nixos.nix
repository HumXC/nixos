{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.aris.greetd;
  args = {
    sessionDir = [config.services.displayManager.sessionData.desktops.out];
  };
  cmd = "${pkgs.aikadm.cmdWithArgs args} > /tmp/aikadm.log 2>&1";
in {
  options.aris.greetd.enable = lib.mkEnableOption "greetd";
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [pkgs.wlsunset];
    services.greetd.enable = true;
    services.greetd.settings.default_session = {
      command = "${pkgs.cage}/bin/cage ${cmd}";
      user = "greeter";
    };
  };
}
