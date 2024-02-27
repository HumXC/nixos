{ lib, ... }@args:
let
  importSysOptions = paths:
    lib.attrsets.mergeAttrsList (
      map (path: import (path + /sys-options.nix) ({ inherit importSysOptions; } // args)) paths
    );
in
{
  hostName = lib.mkOption {
    type = lib.types.str;
    default = "nixos";
    description = "The host name.";
  };
  profileName = lib.mkOption {
    type = lib.types.str;
    default = "";
    description = "The profile name.";
  };
  users = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule {
      options = import ./user-options.nix args;
    });
    default = { };
    description = "The users configuration.";
  };
} // importSysOptions [
  ./modules
  ./hardware
]
