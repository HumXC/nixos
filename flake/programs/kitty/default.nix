{ lib, cfg, importHmIf, ... }:
{
  options.os.programs.kitty.enable = lib.mkEnableOption "kitty";
  config = importHmIf cfg.enable ./home.nix;
}
