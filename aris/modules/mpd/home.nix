{ pkgs, lib, config, ... }:
let
  cfg = config.aris.modules.mpd;
in
{
  config = lib.mkIf cfg.enable {
    services.mpd = {
      enable = true;
      musicDirectory = cfg.musicDirectory;
      extraConfig = ''
        # must specify one or more outputs in order to play audio!
        # (e.g. ALSA, PulseAudio, PipeWire), see next sections
        audio_output {
          type "pipewire"
          name "My PipeWire Output"
        }
      '';
      # Optional:
      network.listenAddress = "any"; # if you want to allow non-localhost connections
    };
    home.packages = with pkgs; [
      ncmpcpp
      mpc-cli
    ];
  };
}
