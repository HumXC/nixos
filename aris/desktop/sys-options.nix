{ lib, ... }@all:
{
  desktop = {
    enable = lib.mkEnableOption "Enable desktop";
  };
}
