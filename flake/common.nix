{ config, inputs, ... }: {
  nixpkgs.config.allowUnfree = true;
  networking.hostName = config.os.hostName;
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      os = config.os;
    };
    sharedModules = [ ];
    users.${config.os.userName} = {
      imports = [ inputs.nur.hmModules.nur inputs.sops-nix.homeManagerModules.sops ];
      home.stateVersion = "22.11";
    };
  };
}
