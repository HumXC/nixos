{ config, sops, ... }: {
  sops = {
    defaultSopsFile = ./../secrets/default.yaml;
    age.keyFile = "/var/lib/sops-nix/key.txt";
    secrets = {
      "password/humxc" = { neededForUsers = true; };
      "password/root" = { neededForUsers = true; };
      clash_url = {
        path = "/etc/clash/url";
      };
      github_token = { };

      id_rsa = {
        sopsFile = ./../secrets/ssh_keys.yaml;
        format = "yaml";
        group = "users";
        path = "/home/humxc/.ssh/id_rsa";
      };
      id_rsa_pub = {
        sopsFile = ./../secrets/ssh_keys.yaml;
        format = "yaml";
        group = "users";
        path = "/home/humxc/.ssh/id_rsa_pub";
      };
    };
  };
}
