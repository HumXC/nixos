{ lib, config, pkgs, cfg, importHm, ... }:
let
  userName = config.os.userName;
in
{
  options.os.programs.zsh.enable = lib.mkEnableOption "zsh";
  options.os.programs.zsh.p10kType = lib.mkOption {
    type = lib.types.str;
    default = "1";
    description = "p10k theme number, " 1 " or " 2 " ";
  };
  config = lib.mkIf cfg.enable {
    environment.shells = with pkgs; [ zsh ];
    programs.zsh = {
      enable = true;
    };
    users.users.${userName}.shell = pkgs.zsh;
    home-manager = (importHm ./home.nix).home-manager;
  };
}

