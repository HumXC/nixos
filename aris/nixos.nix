{ inputs, localFlake, system, self, lib, pkgs, config, ... }@args:
localFlake.withSystem system ({ ... }:
let
  osConfigs = [
    ./desktop
    ./modules
    ./hardware
  ];
  userConfigs = [
    ./desktop
    ./modules
  ];


  getAttrWithList = path: attrs: index:
    let
      val = builtins.getAttr (builtins.elemAt path index) attrs;
    in
    if index == (builtins.length path) - 1 then val
    else getAttrWithList path val (index + 1);

  getAttr = path: attrs: getAttrWithList (lib.splitString "." path) attrs 0;

  # 判断 aris.users.<name> 中 path 的值是否为 value 
  isUsersHave = path: value:
    let
      cfgs = builtins.attrValues config.aris.users;
      vals = map (cfg: getAttr path cfg) cfgs;
    in
    builtins.elem value vals;

  importOs = paths:
    map (path: import (path + /os.nix) ({ inherit isUsersHave importOs; } // args)) paths;
  importUser = name: paths:
    map (path: import (path + /user.nix) ({ inherit name; importUser = importUser name; } // args)) paths;

  arisUser = lib.types.submoduleWith {
    description = "Home Manager module";
    modules = [
      ({ name, ... }: {
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
  options.aris.common = (import ./common.nix args);
  imports = importOs osConfigs;
})
