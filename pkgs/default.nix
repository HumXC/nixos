{ nixpkgs, system, ... }:
let
  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };
  package = packages: builtins.foldl' (acc: name: acc // { "${name}" = pkgs.callPackage ./${name} { }; }) { } packages;
in
package [
  "misans"
  "hmcl-bin"
  "qq"
  "fluent-cursors-theme"
  "orchis-gtk"
  "fcitx5-mellow-themes"
]
