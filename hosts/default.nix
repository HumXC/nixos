{ inputs, outputs, ... }:
let
  mkHost = name:
    let
      host = import ./${name}/host.nix { inherit inputs; };
      system = host.system;
      isUseSops = builtins.pathExists ./${name}/secrets.nix;
    in
    {
      ${name} = inputs.nixpkgs.lib.nixosSystem {
        system = system;
        specialArgs = {
          inherit
            inputs
            outputs
            system;
        } // host.extraSpecialArgs;
        modules = host.extraModules ++ [
          outputs.nixosModules.aris
          (import ./base.nix { profileName = name; host = host; })
        ] ++ (if isUseSops then [ inputs.sops-nix.nixosModules.sops ] else [ ]);
      };
    };
in
(mkHost "roli")
