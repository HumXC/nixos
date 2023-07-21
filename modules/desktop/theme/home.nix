{ config, lib, pkgs, ... }:
let 
  icon = import ./icon.nix {
    lib=lib;
    stdenvNoCC=pkgs.stdenvNoCC;
    fetchFromGitHub=pkgs.fetchFromGitHub;
    gtk3=pkgs.gtk3;
    gnome-themes-extra=pkgs.gnome-themes-extra;
    gtk-engine-murrine=pkgs.gtk-engine-murrine;
    sassc=pkgs.sassc;
  };
  
in
{
  home.packages = (with pkgs; [
    glib
  ]) ++ (with config.nur.repos;[
    
  ]);
  gtk = {
      enable = true;
      font.name = "MiSans";
      theme = {
        # 同步修改 hyprland 配置中的环境变量 GTK_THEME = "Fluent-Dark";
        name = "Fluent-Dark";
        package = config.nur.repos.meain.fluent-theme;
      };
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
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