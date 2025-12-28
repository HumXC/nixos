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
      (pkgs.lib.hideDesktopEntry2 pkgs.qt6Packages.fcitx5-with-addons [
        "org.fcitx.Fcitx5"
        "org.fcitx.fcitx5-migrator"
        "fcitx5-configtool"
        "kcm_fcitx5"
        "kbd-layout-viewer5"
      ])
    ];
    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        addons = with pkgs; [
          qt6Packages.fcitx5-chinese-addons
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
