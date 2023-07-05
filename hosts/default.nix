{ system, self, nixpkgs, inputs, ... }:

let
  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true; # Allow proprietary software
  };

  lib = nixpkgs.lib;
in
{
  laptop = lib.nixosSystem {
    # Laptop profile
    inherit system;
    specialArgs = { inherit inputs; };
    modules = [
      ./system.nix
      ./laptop
      ]++[
      inputs.nur.nixosModules.nur
      inputs.hyprland.nixosModules.default
      inputs.home-manager.nixosModules.home-manager
    ];
  };
} 