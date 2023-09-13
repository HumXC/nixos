{ lib, config, cfg, importHmIf, ... }:
{
  options.os.programs.dunst.enable = lib.mkEnableOption "dunst";
  config = importHmIf cfg.enable ./home.nix;
}
