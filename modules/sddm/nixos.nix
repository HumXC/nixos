{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.aris.sddm;
  sddm-astronaut = pkgs.unstable.sddm-astronaut.override {
    embeddedTheme = "hyprland_kath";
    themeConfig = {
      FormPosition = "left";
      AllowUppercaseLettersInUsernames = true;
      ForceHideCompletePassword = true;
    };
  };
in {
  options.aris.sddm.enable = lib.mkEnableOption "sddm";
  config = lib.mkIf cfg.enable {
    services.xserver.displayManager.setupCommands = "";
    services.xserver.enable = true;
    services.displayManager.sddm = {
      enable = true;
      package = pkgs.unstable.kdePackages.sddm; # qt6 sddm version
      theme = "sddm-astronaut-theme";
      extraPackages = [sddm-astronaut];
    };
    environment.systemPackages = [sddm-astronaut];
  };
}
