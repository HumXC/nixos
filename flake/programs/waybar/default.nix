{ lib, cfg, importHmIf, ... }:
{
  options.os.programs.waybar.enable = lib.mkEnableOption "waybar";
  options.os.programs.waybar.cpuTemperatureHwmonPath = lib.mkOption {
    type = lib.types.str;
    description = "Path to the hwmon directory containing the CPU temperature sensor";
  };
  config = importHmIf cfg.enable ./home.nix;
}
