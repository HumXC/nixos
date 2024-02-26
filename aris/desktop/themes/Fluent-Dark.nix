{ config, lib, pkgs, ... }:
let
  fluent-kde = pkgs.fetchFromGitHub {
    owner = "vinceliuice";
    repo = "Fluent-kde";
    rev = "2021-11-04";
    sha256 = "sha256-7frKNgaX3xSr8bapzWlusNss463RTmPbAfg+N66o44A=";
  };
  os = config.os;
in
rec{
  gtkTheme = "Fluent-Dark";
  gtkThemePackage = pkgs.fluent-gtk-theme;
  iconTheme = "Fluent-dark";
  iconThemePackage = pkgs.fluent-icon-theme;
  cursorTheme = "Fluent-cursors-dark";
  cursorThemePackage = config.nur.repos.humxc.fluent-cursors-theme;

  home = {
    xresources.properties = {
      "Xcursor.path" = "${config.nur.repos.humxc.fluent-cursors-theme}/share/icons";
    };
    home.packages = (with pkgs;
      [
        glib
        libsForQt5.qtstyleplugin-kvantum
      ]);
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
      name = cursorTheme;
      size = os.desktop.theme.cursorSize;
      package = cursorThemePackage;
    };

    gtk = {
      enable = true;
      font.name = "MiSans";
      theme = {
        # 同步修改 hyprland 配置中的环境变量 GTK_THEME = "Fluent-Dark";
        name = gtkTheme;
        package = gtkThemePackage;
      };
      iconTheme = {
        name = iconTheme;
        package = iconThemePackage;
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
