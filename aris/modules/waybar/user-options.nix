{ lib, ... }:
{
  waybar.enable = lib.mkEnableOption "waybar";
  waybar.cpuTemperatureHwmonPath = lib.mkOption {
    type = lib.types.str;
    default = "";
    description = "Path to the hwmon directory containing the CPU temperature sensor";
  };
}
