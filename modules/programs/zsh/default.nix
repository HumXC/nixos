{ pkgs, username, ... }:{
  environment.shells = with pkgs; [ zsh ];
  programs.zsh.enable = true;
  users.users.${username}.shell = pkgs.zsh;
}