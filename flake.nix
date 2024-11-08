{
  description = "Description for the project";

  inputs = {
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    home-manager = {
      url = "github:nix-community/home-manager?ref=release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur.url = "github:nix-community/NUR";

    sops-nix.url = "github:Mic92/sops-nix";

    vscode-server.url = "github:nix-community/nixos-vscode-server";

    ags.url = "github:Aylur/ags";
    nixpkgs-esp-dev = {
      url = "github:mirrexagon/nixpkgs-esp-dev";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };
  outputs = inputs@{ self, flake-parts, nixpkgs, nixpkgs-unstable, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } ({ withSystem, flake-parts-lib, ... }:
      let
        inherit (flake-parts-lib) importApply;
        flakeModules.aris = importApply ./aris { inherit withSystem; };
        flakeModules.hosts = importApply ./hosts { inherit withSystem; };
      in
      {
        imports = [
          flakeModules.aris
          flakeModules.hosts
        ];
        flake = { inherit flakeModules; };
        systems = [ "x86_64-linux" ];

        perSystem = { config, pkgs, system, lib, ... }: {
          devShells = import ./shell { inherit inputs pkgs lib system; };
        };
      });
}
