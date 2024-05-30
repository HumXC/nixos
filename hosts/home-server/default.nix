{ config, pkgs, profileName, ... }:

let
  hostName = "Kana";
  userName = "HumXC";
  rootPassFile = config.sops.secrets."password/root".path;
  userPassFile = config.sops.secrets."password/${userName}".path;
  wwwDataUser = {
    uid = 82;
    isSystemUser = true;
    isNormalUser = false;
    group = "www-data";
  };
in
{
  aris.hostName = hostName;
  aris.users."${userName}" = {
    modules.helix.enable = true;
    modules.zsh.enable = true;
    modules.zsh.p10kType = "2";
  };
  aris.modules.clash = {
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
  users.users.www-data = wwwDataUser;
  users.groups.www-data = { gid = 82; };
  home-manager.users.HumXC.imports = [ ./home.nix ];
  users.users.${userName} = {
    hashedPasswordFile = "${userPassFile}";
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "www-data" ];
  };
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      22
      8080 # nginx
      7890
      9090 # clash
      6800 # aria2
      15136 # ntfy
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
