localFlake: { withSystem, ... }: {
  flake.nixosModules.os = { lib, config, pkgs, system, ... }@all:
    let
      importHm = hmFile: {
        home-manager.users.${config.os.userName}.imports = [ hmFile ];
      };
      importHmIf = condition: hmFile: lib.mkIf condition (importHm hmFile);

      customArgs = {
        inherit importHm importHmIf;
      } // all;

      customImport = path: import path customArgs;
    in
    {
      options.os.userName = lib.mkOption {
        type = lib.types.str;
        description = "The user name.";
      };
      options.os.hostName = lib.mkOption {
        type = lib.types.str;
        default = "nixos";
        description = "The host name.";
      };
      options.os.profileName = lib.mkOption {
        type = lib.types.str;
        description = "The profile name.";
      };
      options.os.config = lib.mkOption {
        default = config;
        description = ''
          NixOS configuration. On NixOS machines, it should be the config itself.
          On non-NixOS machines, all the required keys must be set manually.
        '';
      };
      imports = [
        (import ./common.nix ({ inherit localFlake system; } // all))
        (customImport ./desktop)
        (customImport ./programs)
        (customImport ./hardware)
      ];
    };
}
