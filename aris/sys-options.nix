{ lib, ... }@all:
let
  importSysOptions = paths:
    lib.attrsets.mergeAttrsList (
      map (path: import (path + /sys-options.nix) all) paths
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
      options = import ./user-options.nix all;
    });
    default = { };
    description = "The users configuration.";
  };
} // importSysOptions [
  ./desktop
]
