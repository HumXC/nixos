{ config, pkgs-unstable, ... }:
let
  pkgs = pkgs-unstable;
  hostName = "Roli";
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
      useNvidia = true;
      theme = {
        cursorSize = 34;
        name = "Orchis";
      };
      monitor = [{
        name = "HDMI-A-1";
        size = "1920x1080";
        rate = 100.09;
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
  aris.greetd.enable = true;
  aris.modules.clash = {
    enable = true;
    configUrlFile = config.sops.secrets.clash_url.path;
  };
  aris.users.HumXC.desktop.execOnce = [ "aika-shell" ];
  aris.modules.easyeffects.enable = true;
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
  # virtualisation.docker.enable = true;

  networking.firewall = {
    enable = true;
    allowedUDPPorts = [ 7890 ];
  };
  users.users.${userName} = {
    hashedPasswordFile = "${userPassFile}";
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "libvirtd" "video" "audio" "dialout" "i2c" ];
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
  system.stateVersion = "24.11";
}
