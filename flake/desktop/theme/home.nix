{ config, lib, pkgs, ... }:
let 
  fluent-kde = pkgs.fetchFromGitHub {
    owner = "vinceliuice";
    repo = "Fluent-kde";
    rev = "2021-11-04";
    sha256 = "sha256-7frKNgaX3xSr8bapzWlusNss463RTmPbAfg+N66o44A=";
  };
in{
  home.packages = (with pkgs; [
    glib
    libsForQt5.qtstyleplugin-kvantum
  ]);
  xdg.configFile = {
    "Kvantum/kvantum.kvconfig".text = ''
      [General]
      theme=FluentDark
    '';
    "Kvantum/Fluent" = {
      source = fluent-kde.outPath + "/Kvantum/Fluent";
    };
  };

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    name = "Fluent-cursors-dark";
    size = 28;
    package = config.nur.repos.humxc.fluent-cursors-theme;
  };

  gtk = {
      enable = true;
      font.name = "MiSans";
      theme = {
        # 同步修改 hyprland 配置中的环境变量 GTK_THEME = "Fluent-Dark";
        name = "Fluent-Dark";
        package = pkgs.fluent-gtk-theme;
      };
      iconTheme = {
        name = "Fluent-dark";
        package = pkgs.fluent-icon-theme;
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
}