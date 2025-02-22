{ lib, config, pkgs, ... }:
let
  isEnabled = builtins.elem true
    (map
      (hm: hm.aris.zsh.enable)
      (builtins.attrValues config.home-manager.users));
  package = pkgs.zsh;
  enabledUsers =
    (builtins.filter
      (username: config.home-manager.users."${username}".aris.zsh.enable)
      (builtins.attrNames config.home-manager.users));
  importZsh = lib.attrsets.listToAttrs (map
    (
      username: {
        name = "${username}";
        value = {
          shell = package;
        };
      }
    )
    enabledUsers);
in
{
  config.programs.zsh.enable = isEnabled;
  config.users.users = importZsh;
}

