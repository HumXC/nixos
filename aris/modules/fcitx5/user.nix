{ lib, config, name, ... }: {
  options.modules.fcitx5.enable = lib.mkEnableOption "fcitx5";
  config.desktop.execOnce = [ "${config.home-manager.users."${name}".i18n.inputMethod.package}/bin/fcitx5 -d" ];
}
