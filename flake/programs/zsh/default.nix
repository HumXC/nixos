{ lib, config, pkgs, cfg, importHm, ... }:
let
  userName = config.os.userName;
in
{
  options.os.programs.zsh.enable = lib.mkEnableOption "zsh";
  config = lib.mkIf cfg.enable {
    environment.shells = with pkgs; [ zsh ];
    programs.zsh = {
      enable = true;
    };
    users.users.${userName}.shell = pkgs.zsh;
    home-manager = (importHm ./home.nix).home-manager;
  };
}
