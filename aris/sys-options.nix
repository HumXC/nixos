{ lib, ... }@args:
let
  sysOptions = [
    ./modules
    ./hardware
  ];
  importSysOptions = paths:
    map (path: import (path + /sys-options.nix) ({ inherit importSysOptions; } // args)) paths;
  importUserOptions = name: paths:
    map (path: import (path + /user-options.nix) ({ inherit name; importUserOptions = importUserOptions name; } // args)) paths;
  arisUser = lib.types.submoduleWith {
    description = "Home Manager module";
    modules = [
      ({ name, ... }: {
        imports = importUserOptions name [
          ./desktop
          ./modules
        ];
      })
    ];
  };
in
{
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
  options.aris.common = (import ./common.nix args);
  imports = importSysOptions sysOptions;
}
