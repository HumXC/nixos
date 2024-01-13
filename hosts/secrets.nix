{ config, sops, ... }: {
  sops = {
    defaultSopsFile = ./../secrets/default.yaml;
    age.keyFile = "/var/lib/sops-nix/key.txt";
    secrets = {
      github_token = { };
      clash_url = { };
    };
  };
}
