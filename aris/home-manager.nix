{ inputs, localFlake, system, self, lib, config, ... }@args:
localFlake.withSystem system ({ ... }:
let
  getAris = hmConfig: config.aris.users."${hmConfig.home.username}";
  importHomes = paths: map (path: path + /home.nix) paths;
  stateVersion = "22.11";
  # 同步导入 config.aris.users.username 的配置为 hm 所用
  importUserConfig = users: lib.attrsets.mergeAttrsList (
    map
      (username: {
        "${username}" = {
          home.stateVersion = stateVersion;
          imports = importHomes [
            ./desktop
            ./modules
          ];
        };
      })
      (lib.attrNames users)
  );
in
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { sysConfig = config; inherit getAris importHomes; };
    users = importUserConfig config.aris.users;
    sharedModules = [
      inputs.sops-nix.homeManagerModules.sops
      inputs.vscode-server.homeModules.default
      inputs.nur.hmModules.nur
    ];
  };
})
