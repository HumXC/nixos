{ lib, ... }: {
  clash = {
    enable = lib.mkEnableOption "clash.Meta";
    configUrlFile = lib.mkOption { type = lib.types.str; default = ""; };
    workDir = lib.mkOption { type = lib.types.str; default = "/etc/clash"; };
  };
}
