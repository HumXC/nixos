{ config, sops, ... }:
let sopsFile = ./../../secrets/laptop.yaml;
in {
  sops.secrets = {
    "password/humxc" = { sopsFile = sopsFile; neededForUsers = true; };
    "password/root" = { sopsFile = sopsFile; neededForUsers = true; };
    id_rsa = {
      owner = "humxc";
      path = "/home/humxc/.ssh/id_rsa";
    };
    id_rsa_pub = {
      owner = "humxc";
      path = "/home/humxc/.ssh/id_rsa.pub";
    };
  };
}
