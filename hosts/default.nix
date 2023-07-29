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
    # profilename 是这个配置的名称，此处的 laptop 就是向上数 3 行的那个 laptop
    specialArgs = { inherit inputs; profilename = "laptop"; username="humxc";};
    modules = [
      ./system.nix
      ./laptop
      ]++[
      inputs.nix-ld.nixosModules.nix-ld
      {programs.nix-ld.dev.enable = true;}
      inputs.nur.nixosModules.nur
      inputs.hyprland.nixosModules.default
      inputs.home-manager.nixosModules.home-manager
    ];
  };
} 