{ lib, config, pkgs, name, ... }:
let cfg = config.aris.users."${name}".modules.hyprland;
in {
  options.modules.hyprland = {
    enable = lib.mkEnableOption "hyprland";
    env = lib.mkOption { type = lib.types.attrsOf lib.types.str; default = { }; };
  };
  config =
    let
      hyprland = config.home-manager.users."${name}".wayland.windowManager.hyprland.finalPackage;
      hm_var = "/etc/profiles/per-user/${name}/etc/profile.d/hm-session-vars.sh";
      hy_session =
        let
          bin = pkgs.writeScriptBin "${name}-session" ''
            #!/usr/bin/env sh
            . ${hm_var} && ${hyprland}/bin/Hyprland
          '';
        in
        "${bin}/bin/HumXC-session";
    in
    lib.mkIf cfg.enable {
      desktop.session.command = hy_session;
    };
}
