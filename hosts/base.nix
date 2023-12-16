{ config, nixpkgs, pkgs, lib, inputs, profileName, ... }:
let
  clash-premium = pkgs.callPackage ./../binary/clash-premium.nix { };
in
{
  imports = [ ./${profileName}/hardware-configuration.nix ];
  nixpkgs.config.packageOverrides = pkgs: {
    nixos-github = {
      githubToken = config.sops.secrets.github_token;
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
  services.openssh.enable = true;
  services.dbus.enable = true;
  environment.systemPackages = with pkgs; [
    linux-firmware
    trashy
    git
    wget
    neofetch
    psmisc
    btop
    autojump
  ] ++ [
    clash-premium
  ];

  systemd.services.clash-premium = {
    enable = true;
    description = "Clash daemon, A rule-based proxy in Go.";
    after = [ "network-online.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${clash-premium}/bin/clash-premium -d /etc/clash";
    };
    wantedBy = [ "multi-user.target" ];
  };
  fonts = {
    fontDir.enable = true;
    enableDefaultPackages = true;
    packages = (with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-extra
      noto-fonts-emoji
      nerdfonts
      twemoji-color-font
      babelstone-han
    ]) ++ (with config.nur.repos;[
      humxc.misans
    ]);
    fontconfig = {
      defaultFonts = {
        serif = [ "MiSans" "FiraCode Nerd Font" ];
        sansSerif = [ "MiSans" "FiraCode Nerd Font" ];
        monospace = [ "MiSans" "FiraCode Nerd Font" ];
        emoji = [ "Noto Color Emoji" "Twitter Color Emoji" ];
      };
    };
  };
  nix = {
    settings.auto-optimise-store = true; # Optimise syslinks
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
  boot.swraid.enable = false;
  system.stateVersion = "23.05";
}
