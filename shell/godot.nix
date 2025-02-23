{
  inputs,
  system,
  pkgs,
  ...
}:
with pkgs;
  mkShell {
    NIX_LD_LIBRARY_PATH = lib.makeLibraryPath [
      vulkan-loader
      libGL
      glibc
      xorg.libX11
      xorg.libXcursor
      xorg.libXinerama
      xorg.libXext
      xorg.libXrandr
      xorg.libXrender
      xorg.libXi
      xorg.libXfixes
      libxkbcommon
      alsa-lib
      libpulseaudio
      dbus
      dbus.lib
      speechd
      fontconfig
      fontconfig.lib
    ];

    NIX_LD = builtins.readFile "${stdenv.cc}/nix-support/dynamic-linker";
  }
