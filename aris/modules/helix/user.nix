{ lib, ... }: {
  options.modules.helix.enable = lib.mkEnableOption "helix";
}
