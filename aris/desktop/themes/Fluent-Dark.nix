{ config, pkgs, ... }:
let
  fluent-kde = pkgs.fetchFromGitHub {
    owner = "vinceliuice";
    repo = "Fluent-kde";
    rev = "2021-11-04";
    sha256 = "sha256-7frKNgaX3xSr8bapzWlusNss463RTmPbAfg+N66o44A=";
  };
in
rec
{
  meta = {
    gtkTheme = "Fluent-Dark";
    gtkThemePackage = pkgs.fluent-gtk-theme;
    iconTheme = "Fluent-dark";
    iconThemePackage = pkgs.fluent-icon-theme;
    # cursorTheme = "phinger-cursors";
    # cursorThemePackage = pkgs.phinger-cursors;
    # cursorTheme = "Fluent-cursors-dark";
    # cursorThemePackage = config.nur.repos.humxc.fluent-cursors-theme;
    cursorTheme = "Adwaita";
    cursorThemePackage = pkgs.gnome.adwaita-icon-theme;
  };
  # home 由 home-manager.users.<name>.imports 导入
  home = { config, pkgs, ... }: {
    home.sessionVariables = {
      GTK_THEME = meta.gtkTheme;
      QT_STYLE_OVERRIDE = "kvantum";
    };
    home.packages = [
      pkgs.libsForQt5.qtstyleplugin-kvantum
    ];
    xdg.configFile = {
      "Kvantum/kvantum.kvconfig".text = ''
        [General]
        theme=FluentDark
      '';
      "Kvantum/Fluent" = {
        source = "${fluent-kde}/Kvantum/Fluent";
      };
    };

    home.pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      name = meta.cursorTheme;
      size = config.aris.desktop.theme.cursorSize;
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

      gtk3.extraConfig = {
        Settings = ''
          gtk-application-prefer-dark-theme=1
        '';
      };

      gtk4.extraConfig = {
        Settings = ''
          gtk-application-prefer-dark-theme=1
        '';
      };

    };
  };
}
