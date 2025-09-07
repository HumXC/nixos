{
  config,
  lib,
  pkgs,
  ...
}: let
  isEnabled = builtins.elem true (map
    (hm: hm.aris.daw.enable)
    (builtins.attrValues config.home-manager.users));
in {
  config = lib.mkIf isEnabled {
    musnix.enable = true;
    musnix.kernel.packages = pkgs.linuxPackages_xanmod_latest_rt;
  };
}
