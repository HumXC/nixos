{ config, sops, ... }:
let sopsFile = ./../../secrets/laptop.yaml;
in {
  sops.secrets = {
    "password/humxc" = { sopsFile = sopsFile; neededForUsers = true; };
    "password/root" = { sopsFile = sopsFile; neededForUsers = true; };
    id_rsa = {
      sopsFile = sopsFile;
      format = "yaml";
      owner = "humxc";
      path = "/home/humxc/.ssh/id_rsa";
    };
    id_rsa_pub = {
      sopsFile = sopsFile;
      format = "yaml";
      owner = "humxc";
      path = "/home/humxc/.ssh/id_rsa_pub";
    };
  };
}
