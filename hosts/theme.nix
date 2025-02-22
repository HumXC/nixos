{ pkgs, ... }: {
  stylix.enable = true;
  stylix.autoEnable = true;
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
  };
}