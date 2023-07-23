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

  home.pointerCursor = 
    let 
      getFrom = url: hash: name: {
          gtk.enable = true;
          x11.enable = true;
          name = name;
          size = 28;
          package = 
            pkgs.runCommand "moveUp" {} ''
              mkdir -p $out/share/icons
              ln -s ${pkgs.fetchzip {
                url = url;
                hash = hash;
              }} $out/share/icons/${name}
          '';
        };
    in
      getFrom 
        "https://github.com/ful1e5/fuchsia-cursor/releases/download/v2.0.0/Fuchsia-Pop.tar.gz"
        "sha256-BvVE9qupMjw7JRqFUj1J0a4ys6kc9fOLBPx2bGaapTk="
        "Fuchsia-Pop";
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