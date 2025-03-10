{
  profileName,
  host,
}: {
  config,
  pkgs,
  lib,
  inputs,
  outputs,
  ...
}: let
  isUseSops = builtins.pathExists ./${profileName}/secrets.nix;
in {
  imports =
    [
      ./${profileName}/hardware.nix
      ./${profileName}/config.nix
    ]
    ++ (
      if isUseSops
      then [
        ../secrets
        ./${profileName}/secrets.nix
      ]
      else []
    );
  aris.profileName = profileName;
  programs.nix-ld.enable = true;
  environment.sessionVariables = {
    NIXPKGS_ALLOW_UNFREE = 1;
  };
  nixpkgs = {
    overlays = [
      inputs.nur.overlays.default
      inputs.html-greet.overlays.default
      outputs.overlays.unstable-packages
      outputs.overlays.additions
    ];
    config.allowUnfree = true;
  };
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/etc/nixos";
  };
  console.useXkbConfig = true;
  networking = {
    hostName = host.hostName;
    nameservers = ["223.5.5.5" "223.6.6.6" "114.114.114.114" "114.114.115.115" "1.1.1.1" "1.0.0.1" "8.8.8.8" "8.8.4.4"];
    networkmanager.enable = true;
    hosts = {
      "185.199.109.133" = ["raw.githubusercontent.com"];
      "185.199.111.133" = ["raw.githubusercontent.com"];
      "185.199.110.133" = ["raw.githubusercontent.com"];
      "185.199.108.133" = ["raw.githubusercontent.com"];
    };
  };
  time.timeZone = "Asia/Shanghai";
  i18n.supportedLocales = ["zh_CN.UTF-8/UTF-8" "en_US.UTF-8/UTF-8"];
  i18n.defaultLocale = "en_US.UTF-8";
  environment.systemPackages = with pkgs;
    [
      linux-firmware
      git
      wget
      psmisc
    ]
    ++ (with pkgs.unstable; [
      helix
      alejandra
      cachix
      nixd
    ]);
  environment.variables.NIX_AUTO_RUN = "1";
  nix = {
    registry.os = {
      from .type = "indirect";
      from.id = "os";
      to.type = "path";
      to.path = "/etc/nixos";
    };
    registry.nixpkgs-unstable.flake = inputs.nixpkgs-unstable;
    channel.enable = false;
    settings = {
      substituters = [
        # "https://mirror.sjtu.edu.cn/nix-channels/store"
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      extra-substituters = [
        "https://hyprland.cachix.org"
        "https://nixpkgs-wayland.cachix.org"
        "https://cache.garnix.io"
      ];
      extra-trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
      ];
      trusted-users = ["root" "@wheel"];
      nix-path = "nixpkgs=flake:nixpkgs";
      # https://wiki.hyprland.org/Nix/Cachix/
      experimental-features = [
        "nix-command"
        "flakes"
        "auto-allocate-uids"
        "cgroups"
      ];
      use-cgroups = true;
      auto-optimise-store = true;
      auto-allocate-uids = true;
      keep-outputs = true;
      keep-derivations = true;
    };
    package = pkgs.nixVersions.latest;
    extraOptions = lib.optionalString isUseSops (
      lib.optionalString
      (builtins.hasAttr "nix_access_tokens" config.sops.secrets)
      "!include ${config.sops.secrets.nix_access_tokens.path}"
    );
  };
  system.stateVersion = "24.11";
  boot.swraid.enable = false;
  security.sudo.enable = true;
  security.doas.enable = true;
  security.sudo.wheelNeedsPassword = false;
  security.doas.wheelNeedsPassword = false;
}
