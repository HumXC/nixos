localFlake: { withSystem, system, self, ... }: {
  flake.nixosModules.aris = { lib, pkgs, ... }@args:
    let
      importSysOptions = paths:
        lib.attrsets.mergeAttrsList (
          map (path: import (path + /sys-options.nix) args) paths
        );
    in
    {
      options.aris = import ./sys-options.nix ({ inherit importSysOptions; } // args);
      imports = [
        (import ./home-manager.nix ({ inherit localFlake system self; } // args))
        (import ./nixos.nix ({ inherit localFlake system self; } // args))
      ];
    };

  flake.hmModules.aris = { lib, pkgs, ... }@args:
    {
      options.aris = (import ./user-options.nix args);
    };
}
