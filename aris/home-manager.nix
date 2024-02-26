{ inputs, localFlake, system, self, lib, config, ... }@args:
localFlake.withSystem system ({ ... }:
let
  importHome = paths: map (path: path + /home.nix) paths;
  stateVersion = "22.11";
  # 同步导入 config.aris.users.username 的配置为 hm 所用
  importUserConfig = users: lib.attrsets.mergeAttrsList (
    map
      (username: {
        "${username}" = {
          aris = users."${username}";
          home.stateVersion = stateVersion;
          imports = importHome [
            ./desktop
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
    extraSpecialArgs = { sysConfig = config; };
    users = importUserConfig config.aris.users;
    sharedModules = [
      self.hmModules.aris
      inputs.sops-nix.homeManagerModules.sops
      inputs.vscode-server.homeModules.default
      inputs.nur.hmModules.nur
    ];
  };
})
