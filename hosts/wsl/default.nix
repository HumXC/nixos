{ config, pkgs, profileName, ... }:

let
  hostName = "WSL";
  userName = "HumXC";
  rootPassFile = config.sops.secrets."password/root".path;
  userPassFile = config.sops.secrets."password/${userName}".path;
in
{ 
  wsl.enable = true;
  wsl.defaultUser = "HumXC";
  networking.networkmanager.enable = pkgs.lib.mkForce false;

  aris.hostName = hostName;
  aris.users."${userName}" = {
    modules.helix.enable = true;
    modules.zsh.enable = true;
    modules.zsh.p10kType = "2";
  };
  users.users.root = {
    hashedPasswordFile = "${rootPassFile}";
  };
  home-manager.users.HumXC.imports = [ ./home.nix ];
  users.users.${userName} = {
    uid = 1000;
    hashedPasswordFile = "${userPassFile}";
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "www-data" ];
  };
  environment.sessionVariables = {
    OS_EDITOR = "hx";
    EDITOR = "hx";
  };
  security.doas = {
    enable = true;
    extraConfig = ''
      permit nopass keepenv :wheel
    '';
  };
  system.stateVersion = "24.05";
}
