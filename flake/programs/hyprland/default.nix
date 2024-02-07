{ lib, config, ... }:
let
  cfg = config.os.programs.hyprland;
in
{
  options.os.programs.hyprland = {
    enable = lib.mkEnableOption "hyprland";
    env = lib.mkOption { type = lib.types.attrsOf lib.types.str; default = { }; };
  };
  config = lib.mkIf cfg.enable {
    programs.hyprland.enable = true;
    home-manager.users.${config.os.userName}.imports = [ ./home.nix ];
  };
}
