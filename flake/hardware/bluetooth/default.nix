{ lib, config, pkgs, ...}:
let 
  cfg = config.os.hardware.bluetooth;
in {
  options.os.hardware.bluetooth.enable = lib.mkEnableOption "bluetooth";
  options.os.hardware.bluetooth.autoStart= lib.mkEnableOption "auto unblock bluetooth";
  
  config = lib.mkIf cfg.enable {
    hardware.bluetooth.enable = true;
    services.blueman.enable = true;
    systemd.services.rfkill-unblock-bluethhth = {
      enable = cfg.autoStart;
      description = "Unblock Bluetooth devices at startup";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.util-linux}/bin/rfkill unblock bluetooth";
      };
    };
  };

}
