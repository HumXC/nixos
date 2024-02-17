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
  os.programs.zsh.p10kType = "2";
  os.programs.clash = {
    enable = true;
    configUrlFile = config.sops.secrets.clash_url.path;
  };
  nix.settings.substituters = [ "https://mirror.sjtu.edu.cn/nix-channels/store" ];
  hardware.cpu.intel.updateMicrocode = true;
  users.mutableUsers = false;
  users.users.root = {
    hashedPasswordFile = "${rootPassFile}";
  };
  # docker 容器 nextcloud:fpm-alphin 内的 www-data 的 gid 就是 82
  # 由于 nextcloud 只能操作属于 www-data 的文件，所以添加 www-data 用户组附加到主机的普通用户
  users.users.www-data = {
    uid = 82;
    isSystemUser = true;
    isNormalUser = false;
    group = "www-data";
  };
  users.groups.www-data = { gid = 82; };

  users.users.${userName} = {
    hashedPasswordFile = "${userPassFile}";
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "www-data" ];
  };
  home-manager.users.${userName}.imports = [ ./home.nix ];
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 8080 7890 9090 6800 ];
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
      ],
      "log-opts": {"max-size":"5m"}
    }
  '';
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      Macs = [ "hmac-sha1" "hmac-md5" ];
    };
  };
  services.fail2ban = {
    enable = true;
    # Ban IP after 5 failures
    maxretry = 5;
    ignoreIP = [
      "10.0.0.0/8"
      "172.17.0.0/12"
      "192.168.0.0/16"
    ];
    bantime = "24h";
    bantime-increment = {
      enable = true;
      formula = "ban.Time * math.exp(float(ban.Count+1)*banFactor)/math.exp(1*banFactor)";
      maxtime = "168h";
      overalljails = true;
    };
  };
  services.davfs2.enable = false;
  systemd.mounts = [{
    enable = false;
    what = "http://127.0.0.1:5244/dav/";
    where = "/mnt/webdav";
    description = "Mount WebDAV Service";
    wantedBy = [ "multi-user.target" ];
    type = "davfs";
    options = "uid=1000,file_mode=0664,dir_mode=2775,grpid";
    mountConfig = {
      TimeoutSec = 10;
    };
  }];

  systemd.automounts = [{
    enable = false;
    description = "Automount WebDAV Service";
    where = "/mnt/webdav/";
    wantedBy = [ "remote-fs.target" ];
    automountConfig = {
      TimeoutIdleSec = 30;
    };
  }];
  environment.sessionVariables = {
    OS_EDITOR = "hx";
    EDITOR = "hx";
  };
  virtualisation.docker.enable = true;

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

  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 8 * 1024;
  }];

  console.useXkbConfig = true;

  security.doas = {
    enable = true;
    extraConfig = ''
      permit nopass keepenv :wheel
    '';
  };
}
