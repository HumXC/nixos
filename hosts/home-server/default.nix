{ config, pkgs, profileName, ... }:

let
  hostName = "Kana";
  userName = "humxc";
  rootPassFile = config.sops.secrets."password/root".path;
  userPassFile = config.sops.secrets."password/${userName}".path;
in
{
  os.userName = userName;
  os.hostName = hostName;
  os.profileName = profileName;
  os.programs.helix.enable = true;

  users.mutableUsers = false;
  users.users.root = {
    hashedPasswordFile = "${rootPassFile}";
  };
  users.users.${userName} = {
    hashedPasswordFile = "${userPassFile}";
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
  };
  networking = {
    # 代理配置
    proxy.default = "http://127.0.0.1:7890/";
    proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  };
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];
  };
  services.openssh.enable = true;
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
