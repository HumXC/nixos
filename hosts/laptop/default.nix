{ config, pkgs, inputs, lib, ... }:
let 
  username = "humxc";
in
{
  imports =[
      ./hardware-configuration.nix
      ../../modules/desktop
    ];
  users.mutableUsers = false;
  users.users.root = {
    initialHashedPassword = "$6$b7mGXpPXuF9LA1GB$TbTTOYkPTu4CP5OxjF8yvH2l/TYPn50N1.OQjTQ70YS8lPpWdhxiaR11.vPJa9Jw/H3Mvn5DBdPZzB0BVekF6/";
  };
  networking = {
    hostName = "HumXC"; # Define your hostname.
    proxy.default = "http://127.0.0.1:7890/";
    proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  };
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit username; };
    users.${username} = {
      imports = [
        (import ./home.nix)
        inputs.nur.hmModules.nur
      ];
    };
  };
  users.users.${username} = {
    initialHashedPassword = "$6$CG8wqnmdLVw0sjvX$u6mKfSlSQc9hXFsgkirB3.4LaTGRJtcWcdHgWvggUcn1Ff0Bd.NcyBPLZ.C288gNQqP4hzpoDW8NNzm2jNYzb1";
    # shell = pkgs.zsh;
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "libvirtd" "video" "audio" ];
  };
  boot = {
    supportedFilesystems = [ "ntfs" ];
    # kernelPackages = pkgs.linuxPackages_xanmod_latest;
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
      # "splash"
    ];
    consoleLogLevel = 0;
    # initrd.verbose = false;
  };


  environment = {
    systemPackages = (with pkgs; [
      direnv # 暂时不知道有什么用
      linux-firmware
    ]) ++ (with config.nur.repos;[
      linyinfeng.clash-premium
    ]);
  };

  console.useXkbConfig = true;

  services = {
    xserver.xkbOptions = "caps:escape";
    dbus.packages = [ pkgs.gcr ];
    getty.autologinUser = "${username}";
    # gvfs.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };

  systemd = {
    # user.services.polkit-gnome-authentication-agent-1 = {
    #   description = "polkit-gnome-authentication-agent-1";
    #   wantedBy = [ "graphical-session.target" ];
    #   wants = [ "graphical-session.target" ];
    #   after = [ "graphical-session.target" ];
    #   serviceConfig = {
    #     Type = "simple";
    #     ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
    #     Restart = "on-failure";
    #     RestartSec = 1;
    #     TimeoutStopSec = 10;
    #   };
    # };
  };
  # security.polkit.enable = true;
  security.doas = {
    enable = true;
    extraConfig = ''
      permit nopass keepenv :wheel
    '';
  };

}