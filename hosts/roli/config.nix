{
  config,
  pkgs,
  lib,
  ...
}: let
  rootPassFile = config.sops.secrets."password/root".path;
  userPassFile = config.sops.secrets."password/HumXC".path;
  distro-grub-theme = let
    rev = "v3.2";
  in
    pkgs.stdenv.mkDerivation {
      pname = "distro-grub-theme";
      version = rev;
      src = builtins.fetchurl {
        url = "https://github.com/AdisonCavani/distro-grub-themes/releases/download/${rev}/nixos.tar";
        sha256 = "sha256-oW5DxujStieO0JsFI0BBl+4Xk9xe+8eNclkq6IGlIBY=";
      };
      installPhase = "
        runHook preInsta

        mkdir -p $out/
        tar -xf $src --directory $out

        runHook postInstall
      ";
    };
in {
  aris = {
    greetd.enable = true;
    easyeffects.enable = true;
    soundSystem.enable = true;
    clash = {
      enable = true;
      configUrlFile = config.sops.secrets.clash_url.path;
    };
  };
  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  home-manager.users.HumXC.imports = [./home.nix];
  environment.sessionVariables = {
    OS_EDITOR = "code";
    EDITOR = "code";
  };
  programs.adb.enable = true;
  users.mutableUsers = false;
  users.users.root = {
    hashedPasswordFile = "${rootPassFile}";
  };
  networking.networkmanager.enable = true;
  # virtualisation.docker.enable = true;

  networking.firewall = {
    enable = true;
    allowedUDPPorts = [7890];
  };
  users.users.HumXC = {
    hashedPasswordFile = "${userPassFile}";
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "docker"
      "libvirtd"
      "video"
      "audio"
      "dialout"
      "i2c"
    ];
  };
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  boot = {
    supportedFilesystems = ["ntfs"];
    initrd.verbose = false;
    plymouth.enable = true;
    kernelPackages = pkgs.linuxPackages_xanmod_latest;
    loader = {
      grub = {
        device = "nodev";
        efiSupport = true;
        theme = distro-grub-theme;
        extraEntries = ''
          menuentry "Windows" --class windows{
              search --file --no-floppy --set=root /EFI/Microsoft/Boot/bootmgfw.efi
              chainloader (''${root})/EFI/Microsoft/Boot/bootmgfw.efi
          }
        '';
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/efi";
      };
      timeout = 60;
    };
    kernelParams = ["quiet" "splash"];
    consoleLogLevel = 0;
  };

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024;
    }
  ];
  security.pam.services.astal-auth = {};
  security.doas = {
    enable = true;
    extraConfig = ''
      permit nopass keepenv :wheel
    '';
  };
  system.stateVersion = "25.11";
}
