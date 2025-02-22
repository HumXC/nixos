{ pkgs, ... }:
let
  orchisKde = pkgs.fetchFromGitHub {
    owner = "vinceliuice";
    repo = "Orchis-kde";
    rev = "036e831f545de829a7eaa65f0128322663d406e4";
    sha256 = "sha256-q/ksmL526c6AAJpdokzryEcUsW8aLDGT6WFSbemIUY4=";
  };
  orchisGtk = pkgs.orchis-gtk.override {
    colorVariants = [ "dark" ];
    tweaks = [ "black" ];
  };
in
{
  gtkTheme.name = "Orchis-Dark";
  gtkTheme.package = orchisGtk;
  gtkTheme.darkTheme = true;
  iconTheme.name = "Fluent-dark";
  iconTheme.package = pkgs.fluent-icon-theme;
  cursorTheme.name = "Adwaita";
  cursorTheme.package = pkgs.adwaita-icon-theme;
  kvantumTheme.name = "Orchis-solidDark";
  kvantumTheme.source = "${orchisKde}/Kvantum/Orchis-solid";
}
