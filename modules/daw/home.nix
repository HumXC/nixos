{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: let
  cfg = config.aris.daw;
in {
  options.aris.daw = {
    enable = lib.mkEnableOption "daw";
  };
  config = lib.mkIf cfg.enable (lib.mkMerge [
    (import ./reaper {inherit lib pkgs config inputs;})
    (import ./plugins {inherit lib pkgs config inputs;})
  ]);
}
