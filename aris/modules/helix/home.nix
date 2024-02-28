{ pkgs, lib, config, getAris, ... }:
let
  isEnabled = (getAris config).modules.helix.enable;
in
{
  config = lib.mkIf isEnabled {
    home.packages = with pkgs; [
      helix
    ];
    xdg.configFile."helix/config.toml".source = ./config.toml;
    xdg.configFile."helix/languages.toml".source = ./languages.toml;
  };
}
