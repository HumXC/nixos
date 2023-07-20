{config, ...}:{
  systemd.services.clash-premium = {
    enable = true;
    description="Clash daemon, A rule-based proxy in Go.";
    after= [ "network-online.target" ];
    serviceConfig = {
      Type="simple";
      ExecStart="${config.nur.repos.linyinfeng.clash-premium}/bin/clash-premium -d /etc/clash";

    };
    wantedBy=[ "multi-user.target" ];  
  };
}