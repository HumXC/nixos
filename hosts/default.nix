{ self, inputs, nixpkgs, ... }:
let
  lib = nixpkgs.lib;
  mkHost =
    { name
    , nixpkgs ? inputs.nixpkgs
    , system
    , extraModules ? [ ]
    , extraSpecialArgs ? { }
    }: {
      ${name} =
        nixpkgs.lib.nixosSystem {
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
            inputs.nur.nixosModules.nur
            inputs.home-manager.nixosModules.home-manager
            inputs.nix-ld.nixosModules.nix-ld
            inputs.hyprland.nixosModules.default
            inputs.sops-nix.nixosModules.sops
            self.nixosModules.os
          ];
        };
    };
in
{
  nixosConfigurations = lib.mkMerge [
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
