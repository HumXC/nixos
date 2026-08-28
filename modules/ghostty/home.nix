{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.aris.ghostty;
in {
  options.aris.ghostty.enable = lib.mkEnableOption "ghostty";
  config = lib.mkIf cfg.enable {
    programs.ghostty.enable = true;
    programs.ghostty.package = pkgs.unstable.ghostty;
    programs.ghostty.settings = {
      quit-after-last-window-closed = false;
      font-family = lib.mkForce "Maple Mono NF CN";
      font-family-bold = lib.mkForce "Maple Mono NF CN";
      font-family-italic = lib.mkForce "Maple Mono NF CN";
      font-family-bold-italic = lib.mkForce "Maple Mono NF CN";

      mouse-scroll-multiplier = 0.5;
    };
  };
}
