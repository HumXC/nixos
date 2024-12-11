{ lib, config, pkgs, ... }:
let
  isEnabled = builtins.elem true
    (map
      (aris: aris.desktop.enable)
      (builtins.attrValues config.aris.users));
  themes = import ./themes { inherit config pkgs; };
  # 为每个用户导入主题, 因为主题由 aris.desktop.enable 控制, 所以这里不需要判断是否启用
  importTheme = lib.mapAttrs
    (_: value: {
      imports = [ themes."${value.desktop.theme.name}".home ];
    })
    config.aris.users;
in
{
  config = lib.mkIf isEnabled {
    services.gnome.gnome-keyring.enable = true;
    security.polkit.enable = true;
    programs.light.enable = true; # 用于控制屏幕背光
    home-manager.users = importTheme;

    systemd.user.services.polkit-gnome-authentication-agent-1 = {
      enable = true;
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
    fonts = {
      fontDir.enable = true;
      enableDefaultPackages = true;
      packages = (with pkgs; [
        (nerdfonts.override { fonts = [ "FiraCode" ]; })
        twemoji-color-font
        babelstone-han
      ]) ++ (with pkgs.nur.repos;[
        humxc.misans
      ]);
      fontconfig = {
        defaultFonts = {
          serif = [ "MiSans" "FiraCode Nerd Font" ];
          sansSerif = [ "MiSans" "FiraCode Nerd Font" ];
          monospace = [ "MiSans" "FiraCode Nerd Font" ];
          emoji = [ "Twitter Color Emoji" ];
        };
      };
    };
  };
}
