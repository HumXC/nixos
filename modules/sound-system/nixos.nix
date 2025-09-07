{
  lib,
  config,
  ...
}: let
  cfg = config.aris.soundSystem;
in {
  options.aris.soundSystem.enable = lib.mkEnableOption "Enable the sound system";
  config = lib.mkIf cfg.enable {
    services.pipewire = {
      enable = true;
      jack.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
    };
  };
}
