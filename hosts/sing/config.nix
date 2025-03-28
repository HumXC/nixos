{
  config,
  pkgs,
  ...
}: let
  userName = "HumXC";
  rootPassFile = config.sops.secrets."password/root".path;
  userPassFile = config.sops.secrets."password/${userName}".path;
  wwwDataUser = {
    uid = 82;
    isSystemUser = true;
    isNormalUser = false;
    group = "www-data";
  };
in {
  services.ollama.enable = true;
  services.tlp.enable = true;
  services.upower.enable = true;
  powerManagement.cpuFreqGovernor = "powersave";
  powerManagement.enable = true;
  aris.clash = {
    enable = true;
    configUrlFile = config.sops.secrets.clash_url.path;
  };
  hardware.cpu.intel.updateMicrocode = true;
  users.mutableUsers = false;
  users.users.root = {
    hashedPasswordFile = "${rootPassFile}";
  };
  # docker 容器 nextcloud:fpm-alphin 内的 www-data 的 gid 就是 82
  # 由于 nextcloud 只能操作属于 www-data 的文件，所以添加 www-data 用户组附加到主机的普通用户
  users.users.www-data = wwwDataUser;
  users.groups.www-data = {gid = 82;};
  home-manager.users.HumXC.imports = [./home.nix];
  users.users.${userName} = {
    uid = 1000;
    hashedPasswordFile = "${userPassFile}";
    isNormalUser = true;
    extraGroups = ["wheel" "docker" "www-data"];
  };
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      22
      8080 # nginx
      7890
      9090 # clash
      15136 # ntfy
      7777 # 泰拉瑞亚
    ];
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
      ClientAliveInterval = 60;
      ClientAliveCountMax = 3;
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      Macs = ["hmac-sha1" "hmac-md5"];
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
    daemonSettings = {
      Definition = {
        logtarget = "/var/log/fail2ban/fail2ban.log";
      };
    };
  };
  environment.sessionVariables = {
    OS_EDITOR = "hx";
    EDITOR = "hx";
  };
  virtualisation.docker.enable = true;

  boot = {
    supportedFilesystems = ["ntfs"];
    initrd.verbose = false;
    plymouth.enable = true;
    kernelPackages = pkgs.linuxPackages_xanmod_latest;
    loader = {
      grub = {
        device = "nodev";
        efiSupport = true;
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/efi";
      };
      timeout = 1;
    };
    kernelParams = ["quiet" "splash"];
    consoleLogLevel = 0;
  };

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 8 * 1024;
    }
  ];
}
