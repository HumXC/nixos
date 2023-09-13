{config, pkgs, profileName, ...}@allArgs:

let   
  hostName = "LiKen";
  userName = "humxc";
in {
  os.userName = userName;
  os.hostName = hostName;
  os.profileName = profileName;
  os.desktop = {
    enable = true;
    scale = "1.25";
  };
  os.programs.waybar.cpuTemperatureHwmonPath = "/sys/class/hwmon/hwmon0/temp1_input";
  os.programs.mpd.musicDirectory = "/disk/files/HumXC/Music";
  os.hardware.bluetooth = {
    enable = true;
    autoStart = true;
  };
  home-manager.extraSpecialArgs = {
    os = config.os;
    nur = config.nur;
  };
  home-manager.users.${userName}.imports = [ ./home.nix ];
  users.mutableUsers = false;
  users.users.root = {
    initialHashedPassword = "$6$b7mGXpPXuF9LA1GB$TbTTOYkPTu4CP5OxjF8yvH2l/TYPn50N1.OQjTQ70YS8lPpWdhxiaR11.vPJa9Jw/H3Mvn5DBdPZzB0BVekF6/";
  };
  networking = {
    # 代理配置
    proxy.default = "http://127.0.0.1:7890/";
    proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  };
  users.users.${userName} = {
    initialHashedPassword = "$6$CG8wqnmdLVw0sjvX$u6mKfSlSQc9hXFsgkirB3.4LaTGRJtcWcdHgWvggUcn1Ff0Bd.NcyBPLZ.C288gNQqP4hzpoDW8NNzm2jNYzb1";
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "libvirtd" "video" "audio" "dialout"];
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
  programs.light.enable = true; # 用于控制屏幕背光
  services = {
    xserver.xkbOptions = "caps:escape";
    dbus.packages = [ pkgs.gcr ];
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