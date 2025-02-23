{
  config,
  sops,
  ...
}: {
  sops = {
    defaultSopsFile = ./default.yaml;
    age.keyFile = "/var/lib/sops-nix/key.txt";
    secrets = {
      nix_access_tokens = {};
      github_token_repo = {};
      clash_url = {};
      id_rsa = {};
      id_rsa_pub = {};
    };
  };
}
