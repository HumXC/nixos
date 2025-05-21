{
  lib,
  config,
  ...
}: let
  isEnabled =
    builtins.elem true
    (map
      (hm: hm.aris.fish.enable)
      (builtins.attrValues config.home-manager.users));
  enabledUsers =
    builtins.filter
    (username: config.home-manager.users."${username}".aris.fish.enable)
    (builtins.attrNames config.home-manager.users);
  importFish = lib.attrsets.listToAttrs (map
    (
      username: {
        name = "${username}";
        value = {
          shell = config.home-manager.users."${username}".programs.fish.package;
        };
      }
    )
    enabledUsers);
in {
  config.programs.fish.enable = isEnabled;
  config.users.users = importFish;
}
