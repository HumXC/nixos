{ config, nixpkgs, pkgs, lib, inputs, profileName, ... }:
let
  ifExists = path: lib.optional (builtins.pathExists path) path;
in
{
  imports = [
    ././${profileName}
    ./${profileName}/hardware-configuration.nix
  ]
  ++ ifExists ./${profileName}/secrets.nix;
  home-manager.users.${config.os.userName}.imports = ifExists ./${profileName}/home.nix;
  os.profileName = profileName;
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
    git
    wget
    psmisc
  ];
  environment.variables.NIX_AUTO_RUN = "1";
  nix = {
    channel.enable = false;
    settings = {
      nix-path = lib.mkForce "nixpkgs=flake:nixpkgs";
      # https://wiki.hyprland.org/Nix/Cachix/
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
      experimental-features = [
        "nix-command"
        "flakes"
        "auto-allocate-uids"
        "configurable-impure-env"
        "cgroups"
      ];
      use-cgroups = true;
      auto-optimise-store = true;
      auto-allocate-uids = true;
      keep-outputs = true;
      keep-derivations = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    package = pkgs.nixVersions.unstable;
    registry.nixpkgs.flake = inputs.nixpkgs;
    extraOptions = (
      lib.optionalString
        (builtins.hasAttr "nix_access_tokens" config.sops.secrets)
        "!include ${config.sops.secrets.nix_access_tokens.path}"
    );
  };
  boot.swraid.enable = false;
  system.stateVersion = "23.11";
}
