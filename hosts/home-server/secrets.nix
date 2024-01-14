{ config, sops, ... }:
let sopsFile = ./../../secrets/home-server.yaml;
in {
  sops.secrets = {
    "password/humxc" = { sopsFile = sopsFile; neededForUsers = true; };
    "password/root" = { sopsFile = sopsFile; neededForUsers = true; };
    "davfs_secrets" = { sopsFile = sopsFile; path = "/etc/davfs2/secrets"; };
    id_rsa = {
      owner = "humxc";
      path = "/home/humxc/.ssh/id_rsa";
    };
    id_rsa_pub = {
      owner = "humxc";
      path = "/home/humxc/.ssh/authorized_keys";
    };
  };
}
