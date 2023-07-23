{ config, lib, pkgs, username, ... }:
let 
  # See: https://github.com/fkxxyz/rime-cloverpinyin/wiki/linux#%E5%AE%89%E8%A3%85%E8%AF%A5%E8%BE%93%E5%85%A5%E6%96%B9%E6%A1%88
  version = "1.1.4";
  clover-schema = pkgs.fetchzip {
    url = "https://github.com/fkxxyz/rime-cloverpinyin/releases/download/${version}/clover.schema-${version}.zip";
    sha256 = "sha256-34nPX5RQujAHNJmY0GOV0PjgrYOmC0aTO12XGtTrQKQ=";
    stripRoot = false;
  };

  dataDir = ".local/share/fcitx5/rime";
in
{
  home.file = {
    "${dataDir}"={
      recursive = true;
      source = clover-schema;
    };
    "${dataDir}/default.custom.yaml" = {
      source = ./default.custom.yaml;
    };
  };
}