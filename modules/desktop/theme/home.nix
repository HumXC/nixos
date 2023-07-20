{ config, lib, pkgs, ... }:{
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
      # iconTheme = {
      #   name = "Papirus-Dark";
      #   package = pkgs.papirus-icon-theme;
      # };

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