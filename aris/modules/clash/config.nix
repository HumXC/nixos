{ lib, config, pkgs, ... }:
let
  cfg = config.aris.modules.clash;
  Country_mmdb_url = "https://gitee.com/mirrors/Pingtunnel/raw/master/GeoLite2-Country.mmdb";
  clash-tool = pkgs.stdenv.mkDerivation {
    name = "clash-tool";
    clashinit = pkgs.writeText "clash-init" ''
      #!/usr/bin/env sh
      [ ! -e "${cfg.workDir}" ] && mkdir -p ${cfg.workDir}
      ${lib.optionalString (cfg.configUrlFile!="") "[ ! -e \"${cfg.workDir}/config.yaml\" ] && ${pkgs.curl}/bin/curl -o ${cfg.workDir}/config.yaml \"$(${pkgs.coreutils}/bin/cat ${cfg.configUrlFile})\""}
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
in
{
  config = lib.mkIf cfg.enable {
    networking = {
      # 代理配置
      proxy.default = "http://127.0.0.1:7890/";
      proxy.noProxy = "127.0.0.1,localhost,${config.os.hostName}.lan";
    };
    environment.systemPackages = [ pkgs.clash-meta ];
    systemd.services.clash-meta = {
      enable = true;
      description = "Clash daemon, A rule-based proxy in Go.";
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
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
        ExecStart = ''${pkgs.clash-meta}/bin/clash-meta -d ${cfg.workDir}'';
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}
