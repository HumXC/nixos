{ pkgs, lib, config, ... }:
let
  cfg = config.aris.helix;
in
{
  options.aris.helix.enable = lib.mkEnableOption "helix";
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      helix
    ];
    xdg.configFile."helix/config.toml".source = ./config.toml;
    xdg.configFile."helix/languages.toml".source = ./languages.toml;
  };
}
