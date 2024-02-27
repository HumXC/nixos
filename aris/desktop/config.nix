{ lib, config, isUsersHave, pkgs, ... }@args:
let
  isEnable = isUsersHave "desktop.enable" true;
  themes = import ./themes { inherit config pkgs; };
  importTheme = lib.attrsets.listToAttrs (map
    (
      username:
      let currentTheme = themes."${config.aris.users."${username}".desktop.theme.name}";
      in {
        name = "${username}";
        value = {
          aris.desktop.currentTheme = with currentTheme.meta;lib.mkForce {
            inherit
              gtkTheme gtkThemePackage
              iconTheme iconThemePackage
              cursorTheme cursorThemePackage;
          };
          imports = [ currentTheme.home ];
        };
      }
    )
    (builtins.attrNames config.aris.users));
in
{
  config = lib.mkIf isEnable {
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
