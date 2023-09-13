{ lib, config, ... }:
let 
  cfg = config.os.programs.hyprland;
in
{
  options.os.programs.hyprland ={
    enable = lib.mkEnableOption "hyprland";
  };
  config = lib.mkIf cfg.enable {
    programs.hyprland.enable = true;
    home-manager.users.${config.os.userName}.imports = [ ./home.nix ];
  };
}