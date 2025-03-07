{
  config,
  lib,
  ...
}: let
  cfg = config.aris.helix;
in {
  options.aris.kitty.enable = lib.mkEnableOption "kitty";
  config = lib.mkIf cfg.enable {
    programs.kitty.enable = true;
    programs.kitty.settings = {
      confirm_os_window_close = 0;
    };
  };
}
