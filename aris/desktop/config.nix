{ lib, config, pkgs, ... }@args:
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
  imports = [ (import ./common.nix args) ];
  config = lib.mkIf isEnabled {
    services.gnome.gnome-keyring.enable = true;
    security.polkit.enable = true;
    programs.light.enable = true; # 用于控制屏幕背光
    home-manager.users = importTheme;
    fonts = {
      fontDir.enable = true;
      enableDefaultPackages = true;
      packages = (with pkgs; [
        (nerdfonts.override { fonts = [ "FiraCode" ]; })
        twemoji-color-font
        babelstone-han
      ]) ++ (with config.nur.repos;[
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
