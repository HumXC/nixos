{ config, lib, ... }:
let
  isEnabled = builtins.elem true (map
    (hm: hm.aris.daw.enable)
    (builtins.attrValues config.home-manager.users));
in
{
  config = lib.mkIf isEnabled {
    musnix.enable = true;
  };
}
