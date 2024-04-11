{ pkgs, lib, ... }@args:
let
  shells = map
    (name:
      if name != "default.nix" then {
        ${lib.strings.removeSuffix ".nix" name} = (import ./${name} args);
      } else { })
    (builtins.attrNames (builtins.readDir ../shell));
in
lib.mkMerge shells
