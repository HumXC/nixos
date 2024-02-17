{ config, nixpkgs, pkgs, lib, inputs, profileName, ... }:
{
  imports = [
    ./${profileName}/hardware-configuration.nix
    ./${profileName}/secrets.nix
  ];
  nixpkgs.config.packageOverrides = pkgs: {
    nixos-github = {
      githubToken = config.sops.secrets.github_token_nixos;
    };
  };
  programs.nix-ld.dev.enable = true;
  networking = {
    networkmanager.enable = true;
    hosts = {
      "185.199.109.133" = [ "raw.githubusercontent.com" ];
      "185.199.111.133" = [ "raw.githubusercontent.com" ];
      "185.199.110.133" = [ "raw.githubusercontent.com" ];
      "185.199.108.133" = [ "raw.githubusercontent.com" ];
    };
  };
  time.timeZone = "Asia/Shanghai";
  i18n.supportedLocales = [ "zh_CN.UTF-8/UTF-8" "en_US.UTF-8/UTF-8" ];
  i18n.defaultLocale = "en_US.UTF-8";
  environment.systemPackages = with pkgs; [
    linux-firmware
    trashy
    git
    wget
    nitch
    psmisc
    btop
    autojump
    helix
    diskonaut
  ];
  environment.variables.NIX_AUTO_RUN = "1";
  nix = {
    channel.enable = false;
    settings = {
      nix-path = lib.mkForce "nixpkgs=flake:nixpkgs";
      auto-optimise-store = true; # Optimise syslinks
      # https://wiki.hyprland.org/Nix/Cachix/
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    package = pkgs.nixVersions.unstable;
    registry.nixpkgs.flake = inputs.nixpkgs;
    extraOptions = ''
      experimental-features = nix-command flakes auto-allocate-uids configurable-impure-env
      keep-outputs          = true
      keep-derivations      = true
    '';
  };
  boot.swraid.enable = false;
  system.stateVersion = "23.11";
}
