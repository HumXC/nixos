{ lib, ... }:
{
  waybar.enable = lib.mkEnableOption "waybar";
  waybar.cpuTemperatureHwmonPath = lib.mkOption {
    type = lib.types.str;
    description = "Path to the hwmon directory containing the CPU temperature sensor";
  };
}
