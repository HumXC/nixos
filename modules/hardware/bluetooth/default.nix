{pkgs, ...}:{
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  systemd.services.rfkill-unblock-bluethhth = {
    enable = true;
    description = "Unblock Bluetooth devices at startup";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.util-linux}/bin/rfkill unblock bluetooth";
    };
  };
}
