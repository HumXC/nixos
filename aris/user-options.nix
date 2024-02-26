{ lib, config, ... }@all:
let
  importUserOptions = paths:
    lib.attrsets.mergeAttrsList (
      map (path: import (path + /user-options.nix) all) paths
    );
in
importUserOptions [
  ./desktop
]

