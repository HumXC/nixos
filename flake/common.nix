{ config, inputs, ... }: {
  nixpkgs.config.allowUnfree = true;
  networking.hostName = config.os.hostName;
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      os = config.os;
    };
    users.${config.os.userName} = {
      imports = [ inputs.nur.hmModules.nur ];
      home.stateVersion = "22.11";
    };
  };
}
