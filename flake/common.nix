{ config, inputs, localFlake, system, ... }:
localFlake.withSystem system ({ ... }@all:
{
  nixpkgs.config.allowUnfree = true;
  networking.hostName = config.os.hostName;
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      os = config.os;
    };
    users.${config.os.userName} = {
      imports = [
        inputs.sops-nix.homeManagerModules.sops
        inputs.vscode-server.homeModules.default
        inputs.nur.hmModules.nur
      ];
      home.stateVersion = "22.11";
    };
  };
})
