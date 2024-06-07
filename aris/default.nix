localFlake: { withSystem, self, ... }: {
  flake.nixosModules.aris = { lib, inputs, system, pkgs, ... }@args:
    let
      pkgs-unstable = (import inputs.nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      });
      pkgs-stable = (import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      });
    in
    {
      imports = [
        inputs.home-manager.nixosModules.home-manager
        inputs.hyprland.nixosModules.default
        inputs.nur.nixosModules.nur
        (import ./home-manager.nix ({ inherit localFlake system self pkgs-stable pkgs-unstable; } // args))
        (import ./nixos.nix ({ inherit localFlake system self pkgs pkgs-unstable; } // args))
      ];
    };
}
