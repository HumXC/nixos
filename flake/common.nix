{ config, ...}:{
  nixpkgs.config.allowUnfree = true;
  networking.hostName = config.os.hostName;
  home-manager={
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      os = config.os;
      nur = config.nur;
    };
    users.${config.os.userName}.home.stateVersion = "22.11";
  };
}