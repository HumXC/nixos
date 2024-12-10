{ config, pkgs-unstable, ... }:
let
  pkgs = pkgs-unstable;
  hostName = "Aika";
  userName = "HumXC";
  rootPassFile = config.sops.secrets."password/root".path;
  userPassFile = config.sops.secrets."password/${userName}".path;
  distro-grub-theme =
    let
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
in
{
  nixpkgs.config = {
    allowUnfree = true;
  };
  aris.hostName = hostName;
  aris.users.HumXC = {
    modules = {
      hyprland = {
        enable = true;
        var = {
          BROWSER = "zen";
        };
      };
      mpd = {
        enable = true;
        musicDirectory = "/disk/files/HumXC/Music";
      };
      zsh.enable = true;
      helix.enable = true;
      kitty.enable = true;
      fcitx5.enable = true;
    };
    desktop = {
      enable = true;
      theme = {
        scaleFactor = 1.25;
        cursorSize = 34;
        name = "Orchis";
      };
      monitor = [{
        name = "DP-2";
        size = "2560x1440";
        rate = 180.0;
        scale = 1.25;
      }];
    };
  };
  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  home-manager.users.HumXC.imports = [ ./home.nix ];
  aris.hardware.bluetooth = {
    enable = true;
    autoStart = true;
  };
  aris.modules.clash = {
    enable = true;
    configUrlFile = config.sops.secrets.clash_url.path;
  };
  aris.modules.easyeffects.enable = true;
  aris.users.HumXC.desktop.execOnce = [ "ags run" ];
  services.getty.autologinUser = "HumXC";
  environment.sessionVariables = {
    OS_EDITOR = "code";
    EDITOR = "code";
  };
  programs.adb.enable = true;
  services.udev.packages = [
    pkgs.android-udev-rules
  ];
  # OneDrive https://nixos.wiki/wiki/OneDrive
  services.onedrive.enable = true;
  users.mutableUsers = false;
  users.users.root = {
    hashedPasswordFile = "${rootPassFile}";
  };
  networking.networkmanager.enable = true;

  networking.firewall = {
    enable = true;
    allowedUDPPorts = [ 7890 ];
  };
  users.users.${userName} = {
    hashedPasswordFile = "${userPassFile}";
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "libvirtd" "video" "audio" "dialout" "i2c" "render" ];
  };

  boot = {
    supportedFilesystems = [ "ntfs" ];
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
    kernelParams = [ "quiet" "splash" ];
    consoleLogLevel = 0;
  };


  console.useXkbConfig = true;
  services = {
    dbus = {
      enable = true;
      packages = [ pkgs.gcr ];
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };

  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 16 * 1024;
  }];
  security.pam.services.astal-auth = { };
  security.doas = {
    enable = true;
    extraConfig = ''
      permit nopass keepenv :wheel
    '';
  };
  system.stateVersion = "24.05";
}
