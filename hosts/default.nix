localFlake: { withSystem, self, inputs, ... }:
let
  lib = inputs.nixpkgs.lib;
  mkHost =
    { name
    , nixpkgs ? inputs.nixpkgs
    , system
    , extraModules ? [ ]
    , extraSpecialArgs ? { }
    }: {
      ${name} = withSystem system (ctx@{ config, inputs', ... }: nixpkgs.lib.nixosSystem {
        system = system;
        specialArgs = {
          inherit
            inputs
            nixpkgs
            lib
            system;
          profileName = name;
        } // extraSpecialArgs;
        modules = extraModules ++ [
          ./base.nix
          ./secrets.nix
          inputs.sops-nix.nixosModules.sops
          self.nixosModules.aris
        ];
      });
    };
in
{
  flake.nixosConfigurations = lib.mkMerge [
    (mkHost {
      name = "laptop";
      system = "x86_64-linux";
    })
    (mkHost {
      name = "home-server";
      system = "x86_64-linux";
    })
    (mkHost {
      name = "minimal";
      system = "x86_64-linux";
    })
  ];
}
