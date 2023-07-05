{ config, pkgs, lib, inputs, user, ... }:

{
  nixpkgs.system = "x86_64-linux";

  nixpkgs.config.allowUnfree = true;

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
  
  i18n.defaultLocale = "en_US.UTF-8";
  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      noto-fonts
      source-han-sans
      source-han-serif
      source-code-pro
      fira-code
    ];
  };
  services = {
    openssh = {
      enable = true;
    };
    dbus.enable = true;
  };
  environment = {
    # binsh = "${pkgs.dash}/bin/dash";
    # shells = with pkgs; [ zsh ];
    systemPackages = with pkgs; [
      git
      helix
      wget
      neofetch
    ];
  };
  nix = {
    settings = {
      auto-optimise-store = true; # Optimise syslinks
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 2d";
    };
    package = pkgs.nixVersions.unstable;
    registry.nixpkgs.flake = inputs.nixpkgs;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs          = true
      keep-derivations      = true
    '';
  };

  system = {
    autoUpgrade = {
      enable = false;
      channel = "https://nixos.org/channels/nixos-unstable";
    };
    stateVersion = "23.05";
  };
}