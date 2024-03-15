{ lib, ... }: {
  options.greetd.session = lib.mkOption {
    type = lib.types.listOf (lib.types.submodule {
      options = {
        command = lib.mkOption {
          type = lib.types.str;
          description = "Command.";
        };
        name = lib.mkOption {
          type = lib.types.str;
          description = "Session name.";
        };
      };
    });
    default = [ ];
  };
}
