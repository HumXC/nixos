{ lib, pkgs, ... }: {
  options.aris.hardware.bluetooth = {
    enable = lib.mkEnableOption "bluetooth";
    autoStart = lib.mkEnableOption "auto unblock bluetooth";
  };
}
