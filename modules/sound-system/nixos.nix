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
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };
}
