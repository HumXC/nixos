{inputs, ...}: let
  pathFilter = paths: name: builtins.map (dir: dir + "/${name}") (builtins.filter (dir: builtins.pathExists (dir + "/${name}")) paths);
  modulesPath = [
    ./clash
    ./daw
    ./desktop
    ./easyeffects
    ./fcitx5
    ./helix
    ./hyprland
    ./kitty
    ./mpd
    ./zsh
    ./sddm
    ./vscode
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
      backupFileExtension = "hm-back";
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = {inherit inputs;};
      sharedModules =
        hmImports
        ++ [
          inputs.sops-nix.homeManagerModules.sops
          inputs.vscode-server.homeModules.default
          inputs.stylix.homeManagerModules.stylix
          ({pkgs, ...}: {
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
