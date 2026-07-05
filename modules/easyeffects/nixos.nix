{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.aris.easyeffects;
in {
  options.aris.easyeffects.enable = lib.mkEnableOption "easyeffects";
  config = lib.mkIf cfg.enable {
    systemd.user.services.easyeffects = {
      enable = true;

      description = "EasyEffects daemon";

      wantedBy = ["graphical-session.target"];

      after = [
        "graphical-session.target"
        "pipewire.service"
      ];

      wants = [
        "pipewire.service"
      ];

      serviceConfig = {
        Type = "simple";
        Restart = "on-failure";
        RestartSec = 3;

        ExecStart = "${pkgs.easyeffects}/bin/easyeffects --gapplication-service";
      };
    };
  };
}
