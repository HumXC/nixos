{ config, sops, ... }:
let
  sopsFile = ./../../secrets/home-server.yaml;
  user = config.os.userName;
  homeDirectory = config.home-manager.users."${user}".home.homeDirectory;
in
{
  sops.secrets = {
    "password/${user}" = { sopsFile = sopsFile; neededForUsers = true; };
    "password/root" = { sopsFile = sopsFile; neededForUsers = true; };
    "davfs_secrets" = { sopsFile = sopsFile; path = "/etc/davfs2/secrets"; };
    id_rsa = {
      owner = "${user}";
      path = "${homeDirectory}/.ssh/id_rsa";
    };
    id_rsa_pub = {
      owner = "${user}";
      path = "${homeDirectory}/.ssh/authorized_keys";
    };
  };
}
