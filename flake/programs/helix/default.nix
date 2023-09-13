{ lib, cfg, importHmIf, ... }:
{
  options.os.programs.helix.enable = lib.mkEnableOption "helix";
  config = importHmIf cfg.enable ./home.nix;
}