{ lib, cfg, importHmIf, ... }:
{
  options.os.programs.rofi.enable = lib.mkEnableOption "rofi";
  config = importHmIf cfg.enable ./home.nix;
}