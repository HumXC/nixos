{ lib, ... }: {
  options.modules.rofi.enable = lib.mkEnableOption "rofi";
}
