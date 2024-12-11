localFlake: { withSystem, self, ... }: {
  flake.nixosModules.aris = { lib, inputs, system, pkgs, ... }@args:
    let
      pkgs-unstable = (import inputs.nixpkgs-unstable {
        inherit system;
        overlays = [ inputs.nur.overlay ];
        config.allowUnfree = true;
      });
      pkgs-stable = (import inputs.nixpkgs {
        inherit system;
        overlays = [ inputs.nur.overlay ];
        config.allowUnfree = true;
      });
    in
    {
      imports = [
        inputs.home-manager.nixosModules.home-manager
        (import ./home-manager.nix (args // { inherit localFlake system self pkgs-stable pkgs-unstable inputs; }))
        (import ./nixos.nix (args // { inherit localFlake system self pkgs-stable pkgs-unstable inputs; }))
      ];
    };
}
