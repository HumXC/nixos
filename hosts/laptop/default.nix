{ config, pkgs, ... }:

let
  hostName = "LiKen";
  userName = "humxc";
  rootPassFile = config.sops.secrets."password/root".path;
  userPassFile = config.sops.secrets."password/${userName}".path;
in
{
  os.userName = userName;
  os.hostName = hostName;
  os.desktop = {
    enable = true;
    scaleFactor = 1.25;
    cursorSize = 28;
    theme = "Fluent-dark";
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
  boot = {
    supportedFilesystems = [ "ntfs" ];
    initrd.kernelModules = [ "amdgpu" ];
    initrd.verbose = false;

    kernelPackages = pkgs.linuxPackages_xanmod_latest;
    # bootspec.enable = true;
    loader = {
      # systemd-boot = (lib.mkIf config.boot.lanzaboote.enable) {
      #   enable = lib.mkForce false; #lanzaboote
      #   consoleMode = "auto";
      # };
      grub.device = "nodev";
      grub.efiSupport = true;
      systemd-boot.enable = true;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/efi";
      };
      timeout = 3;
    };
    # lanzaboote = {
    #   enable = true;
    #   pkiBundle = "/etc/secureboot";
    # };
    kernelParams = [
      "quiet"
      "splash"
    ];
    consoleLogLevel = 0;
  };


  console.useXkbConfig = true;
  services = {
    dbus = {
      enable = true;
      packages = [ pkgs.gcr ];
    };
    getty.autologinUser = "${userName}"; # 自动登录
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

  security.polkit.enable = true;
  security.doas = {
    enable = true;
    extraConfig = ''
      permit nopass keepenv :wheel
    '';
  };
}
