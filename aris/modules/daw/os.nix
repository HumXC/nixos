{ config, lib, pkgs-unstable, pkgs, ... }:
let
  cfg = config.aris.modules.daw;
in
{
  options.aris.modules.daw = {
    enable = lib.mkEnableOption "daw";
  };
  config = lib.mkIf cfg.enable {
    security.pam.loginLimits = [
      { domain = "@audio"; type = "-"; item = "rtprio"; value = "95"; }
      { domain = "@audio"; type = "-"; item = "memlock"; value = "unlimited"; }
    ];
    environment.systemPackages = with pkgs;[
      vital
      yoshimi
      lsp-plugins
    ] ++ (with pkgs-unstable;[
      zrythm
    ]);
    environment.sessionVariables = with pkgs;{
      LV2_PLUGINS = lib.concatStringsSep ":" [
        "${lsp-plugins}/lib/lv2"
        "${yoshimi}/lib/lv2"
      ];
      VST3_PLUGINS = lib.concatStringsSep ":" [
        "${vital}/lib/vst3/Vital.vst3/Contents/x86_64-linux"
      ];
    };
  };
}
