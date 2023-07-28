{ pkgs, username, ... }:{
  environment.shells = with pkgs; [ zsh ];
  programs.zsh = {
    enable = true;
    enableCompletion = false;
  };
  users.users.${username}.shell = pkgs.zsh;
}