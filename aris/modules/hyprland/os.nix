{ config, lib, elemUsers, pkgs, ... }:
let
  isEnabled = elemUsers true (cfg: cfg.modules.hyprland.enable);

  hyprland = name: config.home-manager.users."${name}".wayland.windowManager.hyprland.finalPackage;
  hm_var = name: "/etc/profiles/per-user/${name}/etc/profile.d/hm-session-vars.sh";
  hy_session = name:
    let
      bin = pkgs.writeScriptBin "${name}-session" ''
        #!/usr/bin/env sh
        . ${hm_var name} && ${hyprland name}/bin/Hyprland
      '';
    in
    "${bin}/bin/${name}-session";
  ses = builtins.filter (x: x != { }) (map
    (c:
      if c.modules.hyprland.enable then {
        name = "Hyprland";
        command = hy_session c.userName;
        user = c.userName;
      } else { })
    (builtins.attrValues config.aris.users));
in
{
  # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/programs/wayland/hyprland.nix
  config = lib.mkIf isEnabled {
    programs.hyprland.enable = true;
    programs.hyprland.package = config.home-manager.users.HumXC.wayland.windowManager.hyprland.finalPackage;
  };
}
