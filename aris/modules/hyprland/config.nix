{ config, lib, isUsersHave, ... }:
let
  isEnabled = isUsersHave "modules.hyprland.enable" true;
  pkg =
    let
      cfgs = builtins.attrValues config.home-manager.users;
      cfg =
        if (builtins.length cfgs) == 0
        then null
        else builtins.elemAt cfgs 0;
    in
    cfg.wayland.windowManager.hyprland.finalPackage;
in
{
  config = lib.mkIf isEnabled {
    services.xserver.displayManager.sessionPackages = [ pkg ];
    services.xserver.displayManager.session = [{
      manage = "desktop";
      name = "Hyprland";
      start = "${pkg}/bin/Hyprland";
    }];
  };
}
