# 未经测试
{ config, pkgs, profileName, ... }:
let
  hostName = "nixos";
  userName = "nixos";
  # Passwd: nixos
  passwd = "$y$j9T$fQulM.mal02o18dAvQ5gZ0$7V6lBpV8MH.PChjBnu21B6ecWPkEHopnNLGwlgZ35GA";
in
{
  os.userName = userName;
  os.hostName = hostName;

  nix.settings.substituters = [ "https://mirror.sjtu.edu.cn/nix-channels/store" ];
  users.mutableUsers = false;
  users.users.root.hashedPassword = passwd;

  users.users.${userName} = {
    hashedPassword = passwd;
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  environment.sessionVariables.EDITOR = "hx";

  boot = {
    initrd.verbose = false;
    loader = {
      grub.device = "nodev";
      grub.efiSupport = true;
      systemd-boot.enable = true;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/efi";
      };
      timeout = 3;
    };
    kernelParams = [
      "quiet"
      "splash"
    ];
    consoleLogLevel = 0;
  };

  console.useXkbConfig = true;
  security.doas = {
    enable = true;
    extraConfig = ''
      permit nopass keepenv :wheel
    '';
  };
}
