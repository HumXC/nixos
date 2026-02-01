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
  networking.nftables.enable = true;
  services.tlp.enable = true;
  powerManagement.cpuFreqGovernor = "performance";
  powerManagement.enable = false;
  aris.clash = {
    enable = true;
    configUrlFile = config.sops.secrets.clash_url.path;
  };
  aris.soundSystem.enable = true;
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
      25565
      8080 # web
      7890
      15136 # ntfy
      9090
    ];
  };
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
  virtualisation.docker = {
    enable = true;
    daemon.settings = let
      mirrors = [
        "docker.1panel.live"
        "docker.1ms.run"
        "dytt.online"
        "docker-0.unsee.tech"
        "lispy.org"
        "docker.xiaogenban1993.com"
        "666860.xyz"
        "hub.rat.dev"
        "docker.m.daocloud.io"
        "demo.52013120.xyz"
        "proxy.vvvv.ee"
        "registry.cyou"
      ];
    in {
      registry-mirrors = map (mirror: "https://${mirror}") mirrors;
      proxies.no-proxy = builtins.concatStringsSep "," mirrors;
    };
  };
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
