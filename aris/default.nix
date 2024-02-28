localFlake: { withSystem, system, self, ... }: {
  flake.nixosModules.aris = { lib, pkgs, inputs, ... }@args:
    let
      importSysOptions = paths:
        lib.attrsets.mergeAttrsList (
          map (path: import (path + /sys-options.nix) args) paths
        );
    in
    {
      options.aris = import ./sys-options.nix ({ inherit importSysOptions; } // args);
      imports = [
        inputs.home-manager.nixosModules.home-manager
        inputs.nix-ld.nixosModules.nix-ld
        inputs.hyprland.nixosModules.default
        inputs.nur.nixosModules.nur
        (import ./home-manager.nix ({ inherit localFlake system self; } // args))
        (import ./nixos.nix ({ inherit localFlake system self; } // args))
      ];
    };
}
