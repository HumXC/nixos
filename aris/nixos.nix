{ inputs, localFlake, system, self, lib, pkgs, config, ... }@args:
localFlake.withSystem system ({ ... }:
let
  osConfigs = [
    ./desktop
    ./modules
    ./greetd
    ./hardware
  ];
  userConfigs = [
    ./desktop
    ./modules
    ./greetd
  ];

  elemUsers = value: function: builtins.elem value (map function (builtins.attrValues config.aris.users));
  importOs = paths:
    map (path: import (path + /os.nix) ({ inherit elemUsers importOs; } // args)) paths;
  importUser = name: paths:
    map (path: import (path + /user.nix) ({ inherit name; importUser = importUser name; } // args)) paths;

  arisUser = lib.types.submoduleWith {
    description = "Home Manager module";

    modules = [
      ({ name, ... }: {
        options.userName = lib.mkOption {
          type = lib.types.str;
          default = name;
          readOnly = true;
        };
        imports = importUser name userConfigs;
      })
    ];
  };
in
{
  config.networking.hostName = config.aris.hostName;
  options.aris.hostName = lib.mkOption {
    type = lib.types.str;
    default = "nixos";
    description = "The host name.";
  };
  options.aris.profileName = lib.mkOption {
    type = lib.types.str;
    default = "";
    description = "The profile name.";
  };
  options.aris.users = lib.mkOption {
    type = lib.types.attrsOf arisUser;
    default = { };
    description = "The users configuration.";
  };
  imports = importOs osConfigs;
})
