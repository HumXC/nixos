{
  config,
  pkgs,
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
  services.openssh = {
    enable = true;
    settings = {
      ClientAliveInterval = 60;
      ClientAliveCountMax = 3;
      PasswordAuthentication = true;
      KbdInteractiveAuthentication = false;
      Macs = ["hmac-sha1" "hmac-md5"];
    };
  };
  services.blueman.enable = true;
  services.devmon.enable = true;
  services.udisks2.enable = true;
  home-manager.users.HumXC.imports = [./home.nix];
  aris = {
    greetd.enable = true;
    soundSystem.enable = true;
    easyeffects.enable = true;
    clash = {
      enable = true;
      configUrlFile = config.sops.secrets.clash_url.path;
    };
  };
  environment.sessionVariables = {
    OS_EDITOR = "code";
    EDITOR = "code";
  };
  programs.adb.enable = true;
  services.udev.packages = [
    pkgs.android-udev-rules
  ];
  users.mutableUsers = false;
  users.users.root = {
    hashedPasswordFile = "${rootPassFile}";
  };
  networking.networkmanager.enable = true;

  networking.firewall = {
    enable = true;
    allowedUDPPorts = [7890];
  };
  users.users.HumXC = {
    description = "Hum-XC";
    hashedPasswordFile = "${userPassFile}";
    isNormalUser = true;
    extraGroups = ["wheel" "docker" "libvirtd" "video" "audio" "dialout" "i2c" "render" "input"];
  };
  environment.systemPackages = [pkgs.lan-mouse_git];
  boot = {
    supportedFilesystems = ["ntfs"];
    initrd.verbose = false;
    plymouth.enable = true;
    kernelPackages = pkgs.linuxPackages_xanmod_latest;
    # https://github.com/chaotic-cx/nyx/issues/1158
    # kernelPackages = pkgs.linuxPackages_cachyos;

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
}
