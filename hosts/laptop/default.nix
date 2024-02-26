{ config, pkgs, ... }:

let
  hostName = "LiKen";
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
  os.userName = userName;
  os.hostName = hostName;
  os.desktop = {
    enable = true;
    theme = {
      scaleFactor = 1.25;
      cursorSize = 28;
      name = "Fluent-Dark";
    };
  };
  aris.users.HumXC = {
    desktop = {
      enable = true;
      theme = {
        scaleFactor = 1.25;
        cursorSize = 28;
        name = "Fluent-Dark";
      };
    };
  };
  os.programs.clash = {
    enable = true;
    configUrlFile = config.sops.secrets.clash_url.path;
  };
  os.programs.waybar.cpuTemperatureHwmonPath = "/sys/class/hwmon/hwmon0/temp1_input";
  os.programs.mpd.musicDirectory = "/disk/files/HumXC/Music";
  os.programs.hyprland.env = {
    BROWSER = "brave-browser";
  };
  nix.settings.substituters = [ "https://mirror.sjtu.edu.cn/nix-channels/store" ];
  os.hardware.bluetooth = {
    enable = true;
    autoStart = true;
  };
  os.programs.sddm.theme = {
    package = pkgs.sddm-chili-theme;
    config = ''
      [General]
      background=/var/lib/AccountsService/background.png

      ScreenWidth=1920
      ScreenHeight=1080

      blur=true
      recursiveBlurLoops=10
      recursiveBlurRadius=15

      PasswordFieldOutlined=false

      PowerIconSize=
      FontPointSize=18
      AvatarPixelSize=220

      translationReboot=
      translationSuspend=
      translationPowerOff=
    '';
  };
  environment.sessionVariables = {
    OS_EDITOR = "code";
    EDITOR = "code";
  };
  virtualisation.waydroid.enable = true;
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
    allowedUDPPorts = [ 5353 ];
    trustedInterfaces = [ "waydroid0" ];
  };
  users.users.${userName} = {
    hashedPasswordFile = "${userPassFile}";
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "libvirtd" "video" "audio" "dialout" ];
  };
  services.xserver = {
    enable = true;
    # See: https://github.com/NixOS/nixpkgs/blob/nixos-23.11/nixos/modules/services/x11/xserver.nix#L718
    excludePackages = with pkgs; [
      xorg.xorgserver.out
      xorg.xrandr
      xorg.xrdb
      xorg.setxkbmap
      xorg.iceauth
      xorg.xlsclients
      xorg.xset
      xorg.xsetroot
      xorg.xinput
      xorg.xprop
      xorg.xauth
      xterm
      xdg-utils
      xorg.xf86inputevdev.out
      nixos-icons
    ];

  };
  boot = {
    supportedFilesystems = [ "ntfs" ];
    initrd.kernelModules = [ "amdgpu" ];
    initrd.verbose = false;
    plymouth.enable = true;
    kernelPackages = pkgs.linuxPackages_xanmod_latest;
    loader = {
      grub = {
        device = "nodev";
        efiSupport = true;
        theme = distro-grub-theme;
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/efi";
      };
      timeout = 1;
    };
    # lanzaboote = {
    #   enable = true;
    #   pkiBundle = "/etc/secureboot";
    # };
    kernelParams = [ "quiet" "splash" ];
    consoleLogLevel = 0;
  };


  console.useXkbConfig = true;
  services = {
    dbus = {
      enable = true;
      packages = [ pkgs.gcr ];
    };
    gvfs.enable = true; # gnome.nautilus 包的回收站功能需要 See: https://github.com/NixOS/nixpkgs/issues/140860#issuecomment-942769882
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

  security.doas = {
    enable = true;
    extraConfig = ''
      permit nopass keepenv :wheel
    '';
  };
}
