{ lib, ... }: {
  options.modules.kitty.enable = lib.mkEnableOption "kitty";
}
