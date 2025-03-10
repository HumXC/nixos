{
  lib,
  config,
  inputs,
  system,
  ...
}: let
  cfg = config.aris.greetd;
  argv = {
    sessionDir = ["${config.services.displayManager.sessionData.desktops}/share/wayland-sessions"];
    assets = "${inputs.html-greet-frontend.packages.${system}.html-greet-frontend}/share/html-greet-frontend";
  };
  cmd = "${inputs.html-greet.lib.${system}.cage-script argv}";
in {
  options.aris.greetd.enable = lib.mkEnableOption "greetd";
  config = lib.mkIf cfg.enable {
    services.greetd.enable = true;
    services.greetd.settings.default_session = {
      command = cmd;
      user = "greeter";
    };
  };
}
