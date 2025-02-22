{ pkgs, lib, config, ... }:
let
  cfg = config.aris.helix;
in
{
  options.aris.helix.enable = lib.mkEnableOption "helix";
  config = lib.mkIf cfg.enable {
    programs.helix.enable = true;
  };
}
