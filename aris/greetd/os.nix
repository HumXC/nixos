{ lib, config, pkgs, ... }:
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
        agsConfig = pkgs.writeText "greeter-ags-conf"
          (
            ''const ags = "${ags}/bin/ags";'' +
            "const sessions = new Map();" +
            (toString (builtins.map (s: "sessions.set(\"${s.user}\", \"${s.command}\");\n") session) +
            (builtins.readFile ./ags.js))
          );
        hyprConf = pkgs.writeText "greeter-hyprland-conf" ''
          exec-once = ${ags}/bin/ags --config ${agsConfig}; ${hyprland}/bin/hyprctl dispatch exit
          bind = super, p ,exit
          misc {
            disable_hyprland_logo=yes 
          }
        '';
        ags = config.home-manager.users.greeter.programs.ags.package.override {
          extraPackages = with pkgs; [
            glib
            gtksourceview
            webkitgtk
            accountsservice
          ];
        };
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
