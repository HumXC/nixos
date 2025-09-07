{
  inputs,
  outputs,
  ...
}: let
  pathFilter = paths: name: builtins.map (dir: dir + "/${name}") (builtins.filter (dir: builtins.pathExists (dir + "/${name}")) paths);
  modulesPath = [
    ./clash
    ./daw
    ./desktop
    ./easyeffects
    ./fcitx5
    ./fish
    ./greetd
    ./helix
    ./hyprland
    ./kitty
    ./mpd
    ./zsh
    ./sddm
    ./vscode
    ./sound-system
    ./waydroid
  ];
  nixosImports = pathFilter modulesPath "nixos.nix";
  hmImports = pathFilter modulesPath "home.nix";
in {
  aris = {
    imports =
      nixosImports
      ++ [
        inputs.home-manager.nixosModules.home-manager
        inputs.musnix.nixosModules.musnix
        ({lib, ...}: {
          options.aris.profileName = lib.mkOption {
            type = lib.types.str;
            description = "The host profile name.";
          };
        })
      ];
    home-manager = {
      useUserPackages = true;
      extraSpecialArgs = {inherit inputs;};
      sharedModules =
        hmImports
        ++ [
          inputs.sops-nix.homeManagerModules.sops
          inputs.vscode-server.homeModules.default
          inputs.stylix.homeModules.stylix
          ({pkgs, ...}: {
            nixpkgs = {
              overlays = [
                inputs.nur.overlays.default
                outputs.overlays.unstable-packages
                outputs.overlays.additions
                outputs.overlays.extra-lib
              ];
              config.allowUnfree = true;
            };
            programs.git.extraConfig = {
              safe.directory = "/etc/nixos";
              credential."https://github.com".helper = "${pkgs.gh}/bin/gh auth git-credential";
              credential."https://gist.github.com".helper = "${pkgs.gh}/bin/gh auth git-credential";
            };
          })
        ];
    };
  };
}
