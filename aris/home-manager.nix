{ inputs, localFlake, system, self, lib, config, pkgs-stable, pkgs-unstable, ... }@args:
localFlake.withSystem system ({ ... }:
let
  hmModules = [
    ./desktop
    ./modules
  ];
  getAris = hmConfig: config.aris.users."${hmConfig.home.username}";
  importHomes = paths: map (path: path + /home.nix) paths;
  stateVersion = "24.11";
  # 同步导入 config.aris.users.username 的配置为 hm 所用
  importUserConfig =
    lib.mapAttrs
      (_: _: {
        home.stateVersion = stateVersion;
        imports = importHomes hmModules;
      })
      config.aris.users
  ;
  pkgs = pkgs-unstable;
in
{
  home-manager = {
    backupFileExtension = "hm-back";
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit getAris importHomes system inputs pkgs pkgs-stable pkgs-unstable; };
    users = importUserConfig;
    sharedModules = [
      inputs.sops-nix.homeManagerModules.sops
      inputs.vscode-server.homeModules.default
    ];
  };
})
