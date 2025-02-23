{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.aris.clash;
  Country_mmdb_url = "https://mirror.ghproxy.com/https://github.com/Dreamacro/maxmind-geoip/releases/download/20240412/Country.mmdb";
  clash-tool = pkgs.stdenv.mkDerivation {
    name = "clash-tool";
    clashinit = pkgs.writeText "clash-init" ''
      #!/usr/bin/env sh
      [ ! -e "${cfg.workDir}" ] && mkdir -p ${cfg.workDir}
      ${lib.optionalString (cfg.configUrlFile != "") "[ ! -e \"${cfg.workDir}/config.yaml\" ] && ${pkgs.curl}/bin/curl -o ${cfg.workDir}/config.yaml \"$(${pkgs.coreutils}/bin/cat ${cfg.configUrlFile})\""}
      [ ! -e "${cfg.workDir}/Country.mmdb" ] && ${pkgs.curl}/bin/curl -o ${cfg.workDir}/Country.mmdb "${Country_mmdb_url}"
      exit 0
    '';
    unpackPhase = "true";
    installPhase = ''
      mkdir -p $out/bin
      cp $clashinit $out/clash-init
      chmod +x $out/clash-init
    '';
  };
  yacdVersion = "0.3.8";
  yacd = builtins.fetchTarball {
    url = "https://mirror.ghproxy.com/https://github.com/haishanh/yacd/releases/download/v${yacdVersion}/yacd.tar.xz";
    sha256 = "sha256:0wziqgk6lp482qss8khniqc2hbsc3ykagkglrj085d4a3i2q3fk2";
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
      proxy.default = "http://127.0.0.1:7890/";
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
        ExecStartPre = "${clash-tool}/clash-init";
        CapabilityBoundingSet = "CAP_NET_ADMIN CAP_NET_RAW CAP_NET_BIND_SERVICE CAP_SYS_TIME CAP_SYS_PTRACE CAP_DAC_READ_SEARCH";
        AmbientCapabilities = "CAP_NET_ADMIN CAP_NET_RAW CAP_NET_BIND_SERVICE CAP_SYS_TIME CAP_SYS_PTRACE CAP_DAC_READ_SEARCH";
        ExecStart = ''${pkgs.clash-meta}/bin/clash-meta -d ${cfg.workDir} -ext-ui ${yacd}'';
      };
      wantedBy = ["multi-user.target"];
    };
  };
}
