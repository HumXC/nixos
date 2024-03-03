localFlake: { withSystem, system, self, ... }: {
  flake.nixosModules.aris = { lib, pkgs, inputs, ... }@args:
    {
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
