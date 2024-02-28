{ lib, ... }: {
  desktop = {
    execOnce = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Execute commands once after the desktop has finished booting.";
    };
    themes = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = "List of themes.";
    };
  };

  imports = [
  ];
}
