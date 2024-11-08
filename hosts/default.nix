localFlake: { withSystem, self, inputs, ... }:
let
  mkHost =
    { name
    , system
    , extraModules ? [ ]
    , extraSpecialArgs ? { }
    }: {
      ${name} = withSystem system (ctx@{ config, inputs', ... }:
        let
          pkgs-unstable = (import inputs.nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          });
        in
        inputs.nixpkgs.lib.nixosSystem {
          system = system;
          specialArgs = {
            inherit
              inputs
              pkgs-unstable
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
  flake.nixosConfigurations = inputs.nixpkgs.lib.mkMerge [
    (mkHost {
      name = "aika";
      system = "x86_64-linux";
    })
    (mkHost {
      name = "kana";
      system = "x86_64-linux";
    })
    (mkHost {
      name = "sing";
      system = "x86_64-linux";
    })
    (mkHost {
      name = "roli";
      system = "x86_64-linux";
    })
    (mkHost {
      name = "wsl";
      system = "x86_64-linux";
      extraModules = [
        inputs.nixos-wsl.nixosModules.default
      ];
    })
  ];
}
