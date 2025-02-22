{ config, lib, pkgs, ... }:
let
  cfg = config.aris.fcitx5;

  # See: https://github.com/fkxxyz/rime-cloverpinyin/wiki/linux#%E5%AE%89%E8%A3%85%E8%AF%A5%E8%BE%93%E5%85%A5%E6%96%B9%E6%A1%88
  version = "2024.12.12";
  rime-ice = pkgs.fetchzip {
    url = "https://github.com/iDvel/rime-ice/releases/download/${version}/full.zip";
    sha256 = "sha256-1XFpd7rbn1wPglPImrG5wK05aQZBfKyHr2TjlaDa82Y=";
    stripRoot = false;
  };
  setup-rime = pkgs.writeShellScriptBin "setup-rime" ''
    mkdir -p $HOME/.local/share/fcitx5/rime
    cp -r ${rime-ice}/* $HOME/.local/share/fcitx5/rime/
  '';
in
{
  options.aris.fcitx5.enable = lib.mkEnableOption "fcitx5";

  config = lib.mkIf cfg.enable {
    aris.desktop.execOnce = [ "${config.i18n.inputMethod.package}/bin/fcitx5 -d" ];
    home.sessionVariables = {
      GTK_IM_MODULE = lib.mkForce "";
    };
    home.packages = with pkgs; [
      fcitx5-gtk
    ];
    i18n.inputMethod = {
      enabled = "fcitx5";
      fcitx5.addons = with pkgs; [
        fcitx5-rime
        fcitx5-pinyin-moegirl
        fcitx5-pinyin-minecraft
        fcitx5-pinyin-zhwiki
      ];
    };
    xdg.configFile."fcitx5" = {
      recursive = true;
      source = ./fcitx5;
      force = true;
    };
    home.file = {
      ".local/share/fcitx5/themes" = {
        source = pkgs.fcitx5-mellow-themes.overrideAttrs {
          themeName = "graphite";
        };
      };
      ".local/share/fcitx5/rime" = {
        recursive = true;
        source = rime-ice;
        force = true;
      };
      ".local/share/fcitx5/rime/default.custom.yaml".source = ./default.custom.yaml;
    };
  };
}

