{ lib, ... }@args:
let
  importUserOptions = paths:
    lib.attrsets.mergeAttrsList (
      map (path: import (path + /user-options.nix) ({ inherit importUserOptions; } // args)) paths
    );
in
importUserOptions [
  ./desktop
  ./modules
]

