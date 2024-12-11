{ lib, config, pkgs, system, inputs, ... }:
let
  cfg = config.aris.greetd;
  session = builtins.concatLists (builtins.attrValues
    (builtins.mapAttrs
      (user: opts:
        map
          (s: {
            user = "${user}";
            inherit (s) name command;
          })
          opts.greetd.session
      )
      config.aris.users));
  defaultUser = config.aris.greetd.defaultUser;
in
{
  options.aris.greetd.defaultUser = lib.mkOption {
    type = lib.types.str;
    description = "Default user to use";
  };
  options.aris.greetd.enable = lib.mkEnableOption "Greetd";
  config = lib.mkIf cfg.enable {
    home-manager.users.greeter = {
      home.stateVersion = "22.11";
      wayland.windowManager.hyprland.enable = true;
      wayland.windowManager.hyprland.package = pkgs.hyprland;
      wayland.windowManager.hyprland.extraConfig = "-"; # 去除警告
    };
    users.users.greeter = {
      isSystemUser = lib.mkForce false;
      isNormalUser = true;
      group = "greeter";
    };
    services.greetd =
      let
        hyprland = config.home-manager.users.greeter.wayland.windowManager.hyprland.finalPackage;
        # FIXME：
        hyprConf = pkgs.writeText "greeter-hyprland-conf" ''
          exec-once = ${inputs.aika-shell.packages.${system}.aika-greet}/bin/aika-greet -s HumXC "/etc/profiles/per-user/HumXC/bin/Hyprland" > /home/greeter/log.txt 2>&1; ${hyprland}/bin/hyprctl dispatch exit
          misc {
            disable_hyprland_logo=yes 
          }
        '';
      in
      {
        enable = true;
        settings = {
          default_session = {
            command = "${hyprland}/bin/Hyprland --config ${hyprConf}";
            user = "greeter";
          };
        };
      };
  };
}
