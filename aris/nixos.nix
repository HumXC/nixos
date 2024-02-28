{ inputs, localFlake, system, self, lib, pkgs, config, ... }@args:
localFlake.withSystem system ({ ... }:
let
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

  importConfigs = paths:
    (map (path: import (path + /config.nix) ({ inherit importConfigs isUsersHave; } // args)) paths);
in
{
  imports = importConfigs [
    ./desktop
    ./modules
    ./hardware
  ];
})