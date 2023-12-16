{
  description = "Description for the project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur.url = "github:nix-community/NUR";

    nix-ld = {
      url = "github:Mic92/nix-ld";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs = inputs@{ self, nixpkgs, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      perSystem = { system, ... }: {
        # FIXME: didn't work, how to make it work?
        # _module.args.pkgs = import inputs.nixpkgs {
        #   inherit system;
        #   config.allowUnfree = true;
        # };
      };
      imports = [ ./flake ];
      systems = [ "x86_64-linux" ];

      flake = (import ./hosts { inherit nixpkgs self inputs; });
    };
}
