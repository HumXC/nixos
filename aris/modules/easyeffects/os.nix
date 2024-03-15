{ config, lib, pkgs, ... }:
let
  cfg = config.aris.modules.easyeffects;
in
{
  options.aris.modules.easyeffects.enable = lib.mkEnableOption "easyeffects";
  config = lib.mkIf cfg.enable {
    systemd.user.services.easyeffects = {
      enable = true;
      description = "Easyeffects daemon";
      wantedBy = [ "pipewire.socket" ];
      wants = [ "pipewire.socket" ];
      after = [ "pipewire.socket" ];
      serviceConfig = {
        Type = "simple";
        Restart = "on-failure";
        ExecStart = "${pkgs.easyeffects}/bin/easyeffects --gapplication-service";
      };
    };
  };
}
