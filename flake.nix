{
  description = "Description for the project";

  inputs = {
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    nur.url = "github:nix-community/NUR";
    sops-nix.url = "github:Mic92/sops-nix";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs-esp-dev.url = "github:mirrexagon/nixpkgs-esp-dev";
    nixpkgs-esp-dev.inputs.nixpkgs.follows = "nixpkgs-unstable";
    aika-shell.url = "github:HumXC/aika-shell/gtk3";
    aika-shell.inputs.nixpkgs.follows = "nixpkgs-unstable";
    musnix.url = "github:musnix/musnix";
    musnix.inputs.nixpkgs.follows = "nixpkgs-unstable";
    stylix.url = "github:danth/stylix/release-24.11";
    stylix.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = inputs @ {
    self,
    nixpkgs,
    ...
  }: let
    inherit (self) outputs;
    forAllSystems = nixpkgs.lib.genAttrs [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
  in {
    nixosConfigurations = import ./hosts {inherit inputs outputs;};
    nixosModules = import ./modules {inherit inputs outputs;};
    overlays = import ./overlays {inherit inputs;};
    packages = forAllSystems (system:
      import ./pkgs {
        nixpkgs = inputs.nixpkgs;
        system = system;
      });
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
  };
}
