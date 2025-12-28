{
  inputs,
  outputs,
  ...
} @ args: let
  mkHost_ = name: let
    host = import ./${name}/host.nix {inherit inputs;};
    system = host.system;
    isUseSops = builtins.pathExists ./${name}/secrets.nix;
  in {
    ${name} = inputs.nixpkgs.lib.nixosSystem {
      system = system;
      specialArgs =
        {
          inherit
            inputs
            outputs
            system
            ;
        }
        // host.extraSpecialArgs;
      modules =
        host.extraModules
        ++ [
          outputs.nixosModules.aris
          (import ./base.nix {
            profileName = name;
            host = host;
          })
        ]
        ++ (
          if isUseSops
          then [inputs.sops-nix.nixosModules.sops]
          else []
        );
    };
  };
  mkHost = hosts: builtins.foldl' (acc: host: acc // mkHost_ host) {} hosts;
in
  (mkHost [
    "roli"
    "aika"
    "sing"
  ])
  // {
    # nix build .#nixosConfigurations.livecd.config.system.build.isoImage
    livecd = import ./livecd.nix args;
  }
