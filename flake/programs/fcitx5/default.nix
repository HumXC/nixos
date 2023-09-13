{ lib, pkgs, cfg, importHm, ... }:
{
  options.os.programs.fcitx5.enable = lib.mkEnableOption "fcitx5";
  config = lib.mkIf cfg.enable {
    i18n.inputMethod = {
      enabled = "fcitx5";
      fcitx5.addons = with pkgs; [ fcitx5-rime fcitx5-chinese-addons fcitx5-table-extra ];
    };
    home-manager = (importHm ./home.nix).home-manager;
  };
}
