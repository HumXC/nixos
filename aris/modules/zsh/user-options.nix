{ lib, ... }: {
  options.modules.zsh.enable = lib.mkEnableOption "zsh";
  options.modules.zsh.p10kType = lib.mkOption {
    type = lib.types.str;
    default = "1";
    description = ''p10k theme number, "1" or "2"'';
  };
}
