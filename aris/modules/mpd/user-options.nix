{ lib, ... }: {
  options.modules.mpd = {
    enable = lib.mkEnableOption "mpd";
    musicDirectory = lib.mkOption {
      type = lib.types.str;
    };
  };
}
