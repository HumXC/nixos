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
    maple-mono.truetype
    maple-mono.NF-unhinted
    maple-mono.NF-CN-unhinted

    # 系统字体
    misans

    # Emoji
    twemoji-color-font

    # 生僻字 fallback
    babelstone-han
  ];

  stylix.fonts = {
    serif = {
      name = "MiSans";
      package = pkgs.misans;
    };

    sansSerif = {
      name = "MiSans";
      package = pkgs.misans;
    };

    monospace = {
      name = "MiSans";
      package = pkgs.misans;
    };

    emoji = {
      name = "Twitter Color Emoji";
      package = pkgs.twemoji-color-font;
    };
  };

  fonts.fontconfig = {
    enable = true;

    defaultFonts = {
      serif = [
        "MiSans"
        "Twitter Color Emoji"
        "BabelStone Han"
      ];

      sansSerif = [
        "MiSans"
        "Twitter Color Emoji"
        "BabelStone Han"
      ];

      monospace = [
        "MiSans"
        "Twitter Color Emoji"
        "BabelStone Han"
      ];

      emoji = [
        "Twitter Color Emoji"
      ];
    };
  };
}
