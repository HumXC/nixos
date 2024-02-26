{ lib, config, isUsersHave, pkgs, ... }@all:
let
  isEnable = isUsersHave "desktop.enable" true;

in
{
  services.gnome.gnome-keyring.enable = isEnable;
  security.polkit.enable = isEnable;
  programs.light.enable = isEnable; # 用于控制屏幕背光
  fonts = lib.mkIf isEnable {
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
}
