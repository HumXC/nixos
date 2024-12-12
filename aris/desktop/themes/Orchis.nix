{ pkgs, ... }:
let
  orchisKde = pkgs.fetchFromGitHub {
    owner = "vinceliuice";
    repo = "Orchis-kde";
    rev = "036e831f545de829a7eaa65f0128322663d406e4";
    sha256 = "sha256-q/ksmL526c6AAJpdokzryEcUsW8aLDGT6WFSbemIUY4=";
  };
  orchisGtk = pkgs.nur.repos.humxc.orchis-gtk.override {
    colorVariants = [ "dark" ];
    tweaks = [ "black" ];
  };
in
rec
{
  meta = {
    gtkTheme = "Orchis-Dark";
    gtkThemePackage = orchisGtk;
    iconTheme = "Fluent-dark";
    iconThemePackage = pkgs.fluent-icon-theme;
    # cursorTheme = "phinger-cursors-dark";
    # cursorThemePackage = pkgs.phinger-cursors;
    cursorTheme = "Fluent-cursors-dark";
    cursorThemePackage = pkgs.nur.repos.humxc.fluent-cursors-theme;
    # cursorTheme = "Adwaita";
    # cursorThemePackage = pkgs.gnome.adwaita-icon-theme;
  };
  # home 由 home-manager.users.<name>.imports 导入
  home = { config, getAris, pkgs, ... }: {
    home.sessionVariables = {
      GTK_THEME = meta.gtkTheme;
    };

    home.packages = [
      pkgs.libsForQt5.qtstyleplugin-kvantum
    ];
    xdg.configFile = {
      "Kvantum/kvantum.kvconfig".text = ''
        [General]
        theme=Orchis-solidDark
      '';
      "Kvantum/Orchis-solid" = {
        source = "${orchisKde}/Kvantum/Orchis-solid";
      };
    };
    qt = {
      enable = true;
      platformTheme.name = "qtct";
      style.name = "kvantum";
    };
    home.pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      name = meta.cursorTheme;
      size = (getAris config).desktop.theme.cursorSize;
      package = meta.cursorThemePackage;
    };

    gtk = {
      enable = true;
      font.name = "MiSans";
      theme = {
        name = meta.gtkTheme;
        package = meta.gtkThemePackage;
      };
      iconTheme = {
        name = meta.iconTheme;
        package = meta.iconThemePackage;
      };

      gtk3.extraConfig.Settings = ''
        gtk-application-prefer-dark-theme=1
      '';

      gtk4.extraConfig.Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
  };
}
