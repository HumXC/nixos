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
  os.programs.zsh.enable = true;
  users.mutableUsers = false;
  users.users.root = {
    hashedPasswordFile = "${rootPassFile}";
  };
  users.users.${userName} = {
    hashedPasswordFile = "${userPassFile}";
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
  };
  home-manager.users.${userName}.imports = [ ./home.nix ];
  networking = {
    proxy.default = "http://127.0.0.1:7890/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  };
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 8080 ];
  };
  environment.etc."docker/daemon.json".text = ''
    {
      "registry-mirrors": [
        "https://your_code.mirror.aliyuncs.com",
        "https://reg-mirror.qiniu.com",
        "https://gcr-mirror.qiniu.com",
        "https://quay-mirror.qiniu.com",
        "https://hub-mirror.c.163.com",
        "https://mirror.ccs.tencentyun.com",
        "https://docker.mirrors.ustc.edu.cn",
        "https://gcr.mirrors.ustc.edu.cn",
        "https://quay.mirrors.ustc.edu.cn",
        "https://dockerhub.azk8s.cn",
        "https://gcr.azk8s.cn",
        "https://quay.azk8s.cn",
        "http://f1361db2.m.daocloud.io",
        "https://registry.docker-cn.com"
      ]
    }
  '';
  services.openssh.enable = true;
  services.davfs2.enable = true;

  systemd.mounts = [{
    what = "http://172.17.0.1:5244/dav/";
    where = "/mnt/webdav";
    enable = true;
    description = "Mount WebDAV Service";
    after = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    type = "davfs";
    options = "uid=1000,file_mode=0664,dir_mode=2775,grpid";
    mountConfig = {
      TimeoutSec = 30;
    };
  }];
  systemd.automounts = [{
    enable = true;
    description = "Automount WebDAV Service";
    where = "/mnt/webdav/";
    wantedBy = [ "remote-fs.target" ];
    automountConfig = {
      TimeoutIdleSec = 60;
    };
  }];
  environment.sessionVariables = {
    OS_EDITOR = "helix";
    EDITOR = "hx";
  };
  virtualisation.docker.enable = true;
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };
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
