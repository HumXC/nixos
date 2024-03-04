{ inputs, localFlake, system, self, lib, config, ... }@args:
localFlake.withSystem system ({ ... }:
let
  hmModules = [
    ./desktop
    ./modules
  ];
  getAris = hmConfig: config.aris.users."${hmConfig.home.username}";
  importHomes = paths: map (path: path + /home.nix) paths;
  stateVersion = "22.11";
  # 同步导入 config.aris.users.username 的配置为 hm 所用
  importUserConfig =
    lib.mapAttrs
      (_: _: {
        home.stateVersion = stateVersion;
        imports = importHomes hmModules;
      })
      config.aris.users
  ;
in
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit getAris importHomes; };
    users = importUserConfig;
    sharedModules = [
      inputs.ags.homeManagerModules.default
      inputs.sops-nix.homeManagerModules.sops
      inputs.vscode-server.homeModules.default
      inputs.nur.hmModules.nur
    ];
  };
})
