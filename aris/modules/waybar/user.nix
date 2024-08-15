{ lib, pkgs, ... }:
{
  options.modules.waybar.enable = lib.mkEnableOption "waybar";
  options.modules.waybar.cpuTemperatureHwmonPath = lib.mkOption {
    type = lib.types.str;
    default = "";
    description = "Path to the hwmon directory containing the CPU temperature sensor";
  };

}
