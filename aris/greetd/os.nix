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
    environment.systemPackages = [ pkgs.kitty ];
    programs.hyprland.enable = true;
    users.users.greeter = {
      isSystemUser = true;
      group = "greeter";
    };
    services.greetd =
      let
        argv = {
          sessionDirs = [ "${config.services.displayManager.sessionData.desktops}" ];
          defaultSession = "Hyprland";
        };
      in
      {
        enable = true;
        settings = {
          default_session = {
            command = "${inputs.aika-shell.packages.${system}.aika-greet-hyprland argv}";
            user = "greeter";
          };
        };
      };
  };
}
