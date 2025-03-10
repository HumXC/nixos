{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: let
  cfg = config.aris.greetd;
  argv = {
    inherit pkgs;
    html-greet = pkgs.html-greet.default;
    sessionDir = ["${config.services.displayManager.sessionData.desktops}/share/wayland-sessions"];
    assets = "${pkgs.html-greet.frontend}/share/html-greet-frontend";
  };
  cmd = "${inputs.html-greet.lib.cage-script argv}";
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
