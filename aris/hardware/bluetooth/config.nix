{ lib, config, pkgs, ... }:
let
  cfg = config.aris.hardware.bluetooth;
in
{
  config = lib.mkIf cfg.enable {
    hardware.bluetooth.enable = true;
    services.blueman.enable = true;
    systemd.services.rfkill-unblock-bluethhth = lib.mkIf cfg.autoStart {
      enable = true;
      description = "Unblock Bluetooth devices at startup";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.util-linux}/bin/rfkill unblock bluetooth";
      };
    };
  };

}
