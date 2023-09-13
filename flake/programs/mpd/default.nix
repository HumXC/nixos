{ lib, config, cfg, importHm, ... }:
let 
  userName = config.os.userName;
  musicDirectory = config.os.programs.mpd.musicDirectory;
in {
  options.os.programs.mpd.enable = lib.mkEnableOption "mpd";
  options.os.programs.mpd.musicDirectory = lib.mkOption {
    type = lib.types.str;
  };
  config = lib.mkIf cfg.enable {
    home-manager = (importHm ./home.nix).home-manager;
    services.mpd = {
      enable = true;
      user = userName; # https://gitlab.freedesktop.org/pipewire/pipewire/-/issues/609
      musicDirectory = musicDirectory;
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
      startWhenNeeded = true; # systemd feature: only start MPD service upon connection to its socket
    };
    systemd.services.mpd.environment = {
        # https://gitlab.freedesktop.org/pipewire/pipewire/-/issues/609
        XDG_RUNTIME_DIR = "/run/user/1000"; # User-id 1000 must match above user. MPD will look inside this directory for the PipeWire socket.
    };
  };
}