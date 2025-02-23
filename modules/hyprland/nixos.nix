{
  config,
  lib,
  ...
}: let
  isEnabled =
    builtins.elem true
    (map
      (hm: hm.aris.hyprland.enable)
      (builtins.attrValues config.home-manager.users));
in {
  # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/programs/wayland/hyprland.nix
  config = lib.mkIf isEnabled {
    programs.hyprland.enable = true;
  };
}
