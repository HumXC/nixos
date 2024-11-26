{ config, lib, pkgs-unstable, getAris, ... }:
let
  pkgs = pkgs-unstable;
  isEnabled = (getAris config).modules.fcitx5.enable;

  # See: https://github.com/fkxxyz/rime-cloverpinyin/wiki/linux#%E5%AE%89%E8%A3%85%E8%AF%A5%E8%BE%93%E5%85%A5%E6%96%B9%E6%A1%88
  version = "1.1.4";
  clover-schema = pkgs.fetchzip {
    url = "https://github.com/fkxxyz/rime-cloverpinyin/releases/download/${version}/clover.schema-build-${version}.zip";
    sha256 = "sha256-TMiWdSsK1G1sfJgMDJn7iXIjEuIdVwAKKCXQeWHAeQ8=";
    stripRoot = false;
  };
  clover-schema-patch = lib.cleanSourceWith {
    src = clover-schema;
    filter = name: type:
      let
        baseName = baseNameOf name;
      in
      baseName != "clover.key_bindings.yaml";
  };
  dataDir = ".local/share/fcitx5/rime";
in
{
  config = lib.mkIf isEnabled {
    home.sessionVariables = {
      # GTK_IM_MODULE = lib.mkForce "";
    };
    i18n.inputMethod = {
      enabled = "fcitx5";
      fcitx5.addons = with pkgs; [
        fcitx5-rime
        fcitx5-chinese-addons
        fcitx5-table-other
        fcitx5-table-extra
      ];
    };
    xdg.configFile."fcitx5" = {
      recursive = true;
      source = ./fcitx5;
      force = true;
    };
    home.file = {
      ".local/share/fcitx5/themes" = {
        # FIXME: 主题有问题，纯白的
        source = config.nur.repos.humxc.fcitx5-mellow-themes.overrideAttrs {
          themeName = "graphite";
        };
      };

      "${dataDir}" = {
        recursive = true;
        source = clover-schema-patch;
        force = true;
      };
      "${dataDir}/clover.key_bindings.yaml".source = ./clover.key_bindings.yaml;
      "${dataDir}/default.custom.yaml".source = ./default.custom.yaml;
    };
  };
}

