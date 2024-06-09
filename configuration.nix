{ config, lib, pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  nixpkgs.config.allowUnfree = true;
  boot = {
    loader = {
      grub = {
        device = "nodev";
        efiSupport = true;
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/efi";
      };
      timeout = 1;
    };
    consoleLogLevel = 7;
  };
  networking.proxy.default = "http://127.0.0.1:7890/";
  services.xserver.enable = true;


  nix.settings.substituters = [ "https://mirror.sjtu.edu.cn/nix-channels/store" ];
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  users.users.nixos = {
    passwd = "nixos";
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      qq
      vscode
    ];
  };

  environment.systemPackages = with pkgs; [
    helix
    git
    clash-meta
    wget
  ];
  system.stateVersion = "24.05"; # Did you read the comment?

  console.useXkbConfig = true;
  security.doas = {
    enable = true;
    extraConfig = ''
      permit nopass keepenv :wheel
    '';
  };
}

