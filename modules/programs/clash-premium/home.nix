{ config, lib, pkgs, username, ... }:{
  home.packages = with config.nur.repos; [
      linyinfeng.clash-premium
  ];
}