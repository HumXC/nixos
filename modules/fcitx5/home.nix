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
    home.sessionVariables = {
      # GTK_IM_MODULE = lib.mkForce "";
    };
    home.packages = with pkgs; [
      fcitx5-gtk
    ];
    i18n.inputMethod = {
      enabled = "fcitx5";
      fcitx5 = {
        addons = with pkgs; [
          fcitx5-chinese-addons
          fcitx5-pinyin-moegirl
          fcitx5-pinyin-minecraft
          fcitx5-pinyin-zhwiki
        ];
      };
    };
    xdg.configFile."fcitx5" = {
      recursive = true;
      source = ./profile;
      force = true;
    };
    home.activation.removeExistingFcitx5Profile = lib.hm.dag.entryBefore ["checkLinkTargets"] ''
      rm -f "${config.xdg.configHome}/fcitx5/config"
      rm -rf "${config.xdg.configHome}/fcitx5/conf"
    '';
  };
}
