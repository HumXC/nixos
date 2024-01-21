{ pkgs, config, ... }: {
  home.packages = with pkgs; [
    helix
  ];
  xdg.configFile."helix/config.toml".source = ./config.toml;
  xdg.configFile."helix/languages.toml".source = ./languages.toml;
}
