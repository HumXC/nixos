# Home Manager configuration for Stylix
{
  pkgs,
  lib,
  ...
}: {
  stylix.enable = true;
  stylix.autoEnable = true;
  services.hyprpaper.enable = lib.mkForce false;
  stylix.targets.hyprpaper.enable = lib.mkForce false;
  stylix.image = pkgs.fetchurl {
    url = "https://www.pixelstalk.net/wp-content/uploads/2016/05/Epic-Anime-Awesome-Wallpapers.jpg";
    sha256 = "enQo3wqhgf0FEPHj2coOCvo7DuZv+x5rL/WIo4qPI50=";
  };
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/da-one-gray.yaml";
  stylix.iconTheme = {
    enable = true;
    package = pkgs.fluent-icon-theme;
    dark = "Fluent-dark";
    light = "Fluent";
  };
  stylix.cursor = {
    package = pkgs.adwaita-icon-theme;
    name = "Adwaita";
    size = 32;
  };
  home.packages = with pkgs; [
    nerd-fonts.fira-code
    twemoji-color-font
    babelstone-han
    misans
  ];
  stylix.fonts = {
    serif.name = "MiSans";
    serif.package = pkgs.misans;
    sansSerif.name = "MiSans";
    sansSerif.package = pkgs.misans;
    monospace.name = "FiraCode Nerd Font";
    monospace.package = pkgs.nerd-fonts.fira-code;
    emoji.name = "Twitter Color Emoji";
    emoji.package = pkgs.twemoji-color-font;
  };
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      serif = ["MiSans" "FiraCode Nerd Font"];
      sansSerif = ["MiSans" "FiraCode Nerd Font"];
      monospace = ["FiraCode Nerd Font" "MiSans"];
      emoji = ["Twitter Color Emoji"];
    };
  };
}
