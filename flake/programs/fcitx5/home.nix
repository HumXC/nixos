{ config, lib, pkgs, ... }:
let
  # See: https://github.com/fkxxyz/rime-cloverpinyin/wiki/linux#%E5%AE%89%E8%A3%85%E8%AF%A5%E8%BE%93%E5%85%A5%E6%96%B9%E6%A1%88
  version = "1.1.4";
  clover-schema = pkgs.fetchzip {
    url = "https://github.com/fkxxyz/rime-cloverpinyin/releases/download/${version}/clover.schema-build-${version}.zip";
    sha256 = "sha256-34nPX5RQujAHNJmY0GOV0PjgrYOmC0aTO12XGtTrQKQ=";
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
  xdg.configFile."fcitx5" = {
    recursive = true;
    source = ./fcitx5;
  };
  home.file = {
    ".local/share/fcitx5/themes/just-dark" = {
      source = ./just-dark;
    };

    "${dataDir}" = {
      recursive = true;
      source = clover-schema-patch;
    };
    "${dataDir}/clover.key_bindings.yaml".source = ./clover.key_bindings.yaml;
    "${dataDir}/default.custom.yaml".source = ./default.custom.yaml;
  };
}

