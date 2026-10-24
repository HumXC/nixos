{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.aris.clash;
  zashboardVersion = "3.28.0";
  zashboard = fetchTarball {
    url = "https://ghfast.top/https://github.com/Zephyruso/zashboard/releases/download/v${zashboardVersion}/dist-misans-only.zip";
    sha256 = "sha256:17lx3andlg2p2y2ijqwlci7pjdlpnxabycmjjnzddbzhwcm8qb91";
  };
in {
  options.aris.clash = {
    enable = lib.mkEnableOption "clash.Meta";
    configUrlFile = lib.mkOption {
      type = lib.types.str;
      default = "";
    };
    workDir = lib.mkOption {
      type = lib.types.str;
      default = "/etc/clash";
    };
  };
  config = lib.mkIf cfg.enable {
    networking = {
      proxy.default = "http://127.0.0.1:7890";
      proxy.noProxy = "127.0.0.1,localhost,${config.networking.hostName}.lan";
    };
    environment.systemPackages = [pkgs.clash-meta];
    systemd.services.clash-meta = {
      enable = true;
      description = "Clash daemon, A rule-based proxy in Go.";
      wants = ["network-online.target"];
      after = ["network-online.target"];
      serviceConfig = {
        Environment = [
          "all_proxy="
          "http_proxy="
          "https_proxy="
        ];
        Type = "simple";
        LimitNPROC = 500;
        LimitNOFILE = 1000000;
        CapabilityBoundingSet = "CAP_NET_ADMIN CAP_NET_RAW CAP_NET_BIND_SERVICE CAP_SYS_TIME CAP_SYS_PTRACE CAP_DAC_READ_SEARCH";
        AmbientCapabilities = "CAP_NET_ADMIN CAP_NET_RAW CAP_NET_BIND_SERVICE CAP_SYS_TIME CAP_SYS_PTRACE CAP_DAC_READ_SEARCH";
        ExecStart = ''${pkgs.clash-meta}/bin/clash-meta -d ${cfg.workDir} -ext-ui ${zashboard}'';
      };
      wantedBy = ["multi-user.target"];
    };
  };
}
