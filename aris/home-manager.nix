{ inputs, localFlake, system, self, lib, config, ... }@args:
localFlake.withSystem system ({ ... }:
let
  importHomes = paths: map (path: path + /home.nix) paths;
  stateVersion = "22.11";
  # 同步导入 config.aris.users.username 的配置为 hm 所用
  importUserConfig = users: lib.attrsets.mergeAttrsList (
    map
      (username: {
        "${username}" = {
          aris = users."${username}";
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
    extraSpecialArgs = { sysConfig = config; inherit importHomes; };
    users = importUserConfig config.aris.users;
    sharedModules = [
      self.hmModules.aris
      inputs.sops-nix.homeManagerModules.sops
      inputs.vscode-server.homeModules.default
      inputs.nur.hmModules.nur
    ];
  };
})
