{ config, sops, ... }:
let
  sopsFile = ./../../secrets/laptop.yaml;
  user = "HumXC";
  homeDirectory = config.home-manager.users."${user}".home.homeDirectory;
in
{
  sops.secrets = {
    "password/${user}" = { sopsFile = sopsFile; neededForUsers = true; };
    "password/root" = { sopsFile = sopsFile; neededForUsers = true; };
    id_rsa = {
      mode = "0400";
      owner = "${user}";
      path = "${homeDirectory}/.ssh/id_rsa";
    };
    id_rsa_pub = {
      mode = "0400";
      owner = "${user}";
      path = "${homeDirectory}/.ssh/id_rsa.pub";
    };
  };
}





