localFlake: { withSystem, system, self, ... }: {
  flake.nixosModules.aris = { lib, config, pkgs, ... }@args:
    {
      options.aris = import ./sys-options.nix args;
      imports = [
        (import ./home-manager.nix ({ inherit localFlake system self; } // args))
        (import ./nixos.nix ({ inherit localFlake system self; } // args))
      ];
    };
  flake.hmModules.aris = { lib, config, pkgs, ... }@args:
    {
      options.aris = (import ./user-options.nix args);
    };
}
