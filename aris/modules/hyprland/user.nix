{ lib, ... }: {
  options.modules.hyprland = {
    enable = lib.mkEnableOption "hyprland";
    env = lib.mkOption { type = lib.types.attrsOf lib.types.str; default = { }; };
  };
}
