{
  lib,
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs.unstable; [
    crosspipe
    noise-repellent
    (vital.overrideAttrs (finalAttrs: rec {
      version = "1.6.4";
      src = fetchzip {
        url = "https://builds.vital.audio/VitalAudio/vital/${
          builtins.replaceStrings ["."] ["_"] version
        }/VitalInstaller.zip";
        hash = "sha256-w4lHlcqkzPcUm+HmERs8+nLCgP1BWNnMSXqdV9Fyc/Q=";
      };
    }))
    yoshimi
    sfizz-ui
    (pkgs.lib.hideDesktopEntry lsp-plugins [])
  ];
}
