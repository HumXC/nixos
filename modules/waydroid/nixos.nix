{config, ...}: let
  isEnabled =
    builtins.elem true
    (map
      (hm: hm.aris.waydroid.enable)
      (builtins.attrValues config.home-manager.users));
in {
  config.virtualisation.waydroid.enable = isEnabled;
}
