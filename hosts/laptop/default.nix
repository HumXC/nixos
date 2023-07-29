{ config, pkgs, inputs, lib, profilename, username, ... }:
let 
  hostName = "HumXC";
  waybarConfig = {
    cpuTemperatureHwmonPath = ''"/sys/class/hwmon/hwmon0/temp1_input"'';
  };
in
{
  imports =[
      ./hardware-configuration.nix
      ../../modules/desktop
      ../../modules/hardware/bluetooth # 开启蓝牙功能
    ];
  users.mutableUsers = false;
  users.users.root = {
    initialHashedPassword = "$6$b7mGXpPXuF9LA1GB$TbTTOYkPTu4CP5OxjF8yvH2l/TYPn50N1.OQjTQ70YS8lPpWdhxiaR11.vPJa9Jw/H3Mvn5DBdPZzB0BVekF6/";
  };
  networking = {
    hostName = hostName; # 主机名
    # 代理配置
    proxy.default = "http://127.0.0.1:7890/";
    proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  };
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit profilename username waybarConfig; };
    users.${username} = {
      imports = [
        (import ./home.nix)
        inputs.nur.hmModules.nur
      ];
    };
  };
  users.users.${username} = {
    initialHashedPassword = "$6$CG8wqnmdLVw0sjvX$u6mKfSlSQc9hXFsgkirB3.4LaTGRJtcWcdHgWvggUcn1Ff0Bd.NcyBPLZ.C288gNQqP4hzpoDW8NNzm2jNYzb1";
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "libvirtd" "video" "audio" ];
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


  environment = {
    systemPackages = (with pkgs; [
      linux-firmware
    ]);
  };

  console.useXkbConfig = true;
  programs.light.enable = true; # 用于控制屏幕背光
  services = {
    xserver.xkbOptions = "caps:escape";
    dbus.packages = [ pkgs.gcr ];
    getty.autologinUser = "${username}"; # 自动登录
    gvfs.enable = true; # gnome.nautilus 包的回收站功能需要 See: https://github.com/NixOS/nixpkgs/issues/140860#issuecomment-942769882
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };

  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
  security.polkit.enable = true;
  security.doas = {
    enable = true;
    extraConfig = ''
      permit nopass keepenv :wheel
    '';
  };

}