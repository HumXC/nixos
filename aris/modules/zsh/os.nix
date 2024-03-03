{ lib, config, pkgs, elemUsers, ... }:
let
  isEnabled = elemUsers true (cfg: cfg.modules.zsh.enable);
  package = pkgs.zsh;
  enabledUsers =
    (builtins.filter
      (username: config.aris.users."${username}".modules.zsh.enable)
      (builtins.attrNames config.aris.users));
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

