{ lib, config, pkgs, name, ... }:
let
  cfg = config.aris.users.${name}.modules.hyprland;
  pkg = config.home-manager.users.${name}.wayland.windowManager.hyprland.finalPackage;

  hm_var = "/etc/profiles/per-user/${name}/etc/profile.d/hm-session-vars.sh";
  hy_session =
    let
      bin = pkgs.writeScriptBin "${name}-session" ''
        #!/usr/bin/env sh
        . ${hm_var } && ${pkg}/bin/Hyprland
      '';
    in
    "${bin}/bin/${name}-session";
in
{
  options.modules.hyprland = {
    enable = lib.mkEnableOption "hyprland";
    env = lib.mkOption { type = lib.types.attrsOf lib.types.str; default = { }; };
  };
  config = lib.mkIf cfg.enable {
    greetd.session = [{
      name = "Hyprland";
      command = hy_session;
    }];
  };
}

