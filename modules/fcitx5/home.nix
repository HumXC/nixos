{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.aris.fcitx5;
in {
  options.aris.fcitx5.enable = lib.mkEnableOption "fcitx5";

  config = lib.mkIf cfg.enable {
    aris.desktop.execOnce = ["${config.i18n.inputMethod.package}/bin/fcitx5 -d"];
    home.packages = with pkgs; [
      fcitx5-gtk
    ];
    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        addons = with pkgs; [
          fcitx5-chinese-addons
          fcitx5-pinyin-moegirl
          fcitx5-pinyin-minecraft
          fcitx5-pinyin-zhwiki
        ];
        waylandFrontend = false;
        settings = import ./settings.nix;
      };
    };
  };
}
