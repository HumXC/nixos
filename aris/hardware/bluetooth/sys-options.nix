{ lib, pkgs, ... }: {
  bluetooth = {
    enable = lib.mkEnableOption "bluetooth";
    autoStart = lib.mkEnableOption "auto unblock bluetooth";
  };
}
