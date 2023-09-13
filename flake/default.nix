{    
  flake = {
    nixosModules.os = {lib, config, pkgs, ...}@all:
    let 
      importHm = hmFile:{
        home-manager.users.${config.os.userName}.imports = [ hmFile ];
      };
      importHmIf = condition: hmFile: lib.mkIf condition (importHm hmFile);

      customArgs = {
        inherit importHm importHmIf;
      }//all;

      customImport = path: import path customArgs;
    in {
      options.os.userName= lib.mkOption {
        type = lib.types.str;
        description = "The user name.";
      };
      options.os.hostName= lib.mkOption {
        type = lib.types.str;
        default = "nixos";
        description = "The host name.";
      }; 
     options.os.profileName= lib.mkOption {
        type = lib.types.str;
        description = "The profile name.";
      }; 
      imports = [
        (customImport ./common.nix)
        (customImport ./desktop)
        (customImport ./programs)
        (customImport ./hardware)
      ];
    };
  };
  

}