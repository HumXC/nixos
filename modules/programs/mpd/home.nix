{ pkgs, ... }:{
  home.packages = with pkgs; [
    ncmpcpp
    mpc-cli
  ];
}