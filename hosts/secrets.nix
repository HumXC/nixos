{ config, sops, ... }: {
  sops = {
    defaultSopsFile = ./../secrets/default.yaml;
    age.keyFile = "/var/lib/sops-nix/key.txt";
    secrets = {
      github_token_nixos = { };
      github_token_repo = { };
      clash_url = { };
      id_rsa = { };
      id_rsa_pub = { };
    };
  };
}
