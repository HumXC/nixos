{ self, inputs, nixpkgs, ... }:
let  
  lib = nixpkgs.lib;
  mkHost = {
    name,
    nixpkgs ? inputs.nixpkgs,
    system,
    extraModules ? [],
    specialArgs ? [],
  }: {
    ${name} =let 
      profile = ././${name};
    in  
      nixpkgs.lib.nixosSystem {
        system = system;
        specialArgs = {inherit 
          inputs
          nixpkgs
          lib
          system;
          profileName = name;
        };
        modules = extraModules ++ [
          ./base.nix
          profile
          inputs.nur.nixosModules.nur
          inputs.home-manager.nixosModules.home-manager
          inputs.nix-ld.nixosModules.nix-ld
          inputs.hyprland.nixosModules.default
          self.nixosModules.os
        ];
    };
  };
in {
  nixosConfigurations = lib.mkMerge [
    (mkHost {
      name = "laptop";
      system = "x86_64-linux";
    })
  ];
}