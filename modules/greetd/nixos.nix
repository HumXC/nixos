{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.aris.greetd;
in {
  options.aris.greetd.defaultUser = lib.mkOption {
    type = lib.types.str;
    description = "Default user to use";
  };
  options.aris.greetd.enable = lib.mkEnableOption "Greetd";
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [pkgs.kitty];
    programs.hyprland.enable = true;
    users.users.greeter = {
      isSystemUser = true;
      group = "greeter";
    };
    services.greetd = let
      argv = {
        inherit pkgs;
        sessionDirs = ["${config.services.displayManager.sessionData.desktops}/share/wayland-sessions"];
        wallpaperDir = "/home/greeter/wallpaper";
        cageEnv.LANG = "zh_CN.UTF-8";
      };
      cmd = "${inputs.aikadm.lib.cage-script argv}";
    in {
      enable = true;
      settings.default_session = {
        command = cmd;
        user = "greeter";
      };
    };
  };
}
