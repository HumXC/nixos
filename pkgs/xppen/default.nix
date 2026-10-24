{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  qt5,
  python3,
  coreutils,
  libusb1,
  libGL,
  libx11,
  libxtst,
  libxrandr,
}: let
  source = import ./sources.nix {inherit fetchurl;};
in
  stdenv.mkDerivation {
    pname = "xppen";
    inherit (source) version src;

    nativeBuildInputs = [autoPatchelfHook qt5.wrapQtAppsHook python3];
    buildInputs = [
      qt5.qtbase
      qt5.qtwayland
      libusb1
      libGL
      # Required by the vendor ELF even when the GUI runs on Wayland.
      libx11
      libxtst
      libxrandr
      (lib.getLib stdenv.cc.cc)
    ];

    dontConfigure = true;
    dontBuild = true;
    dontWrapQtApps = true;

    installPhase = ''
      runHook preInstall

      mkdir -p "$out/lib/pentablet" "$out/bin"
      cp -r App/usr/lib/pentablet/{PenTablet,UI,doc} "$out/lib/pentablet/"
      chmod +x "$out/lib/pentablet/PenTablet"
      mkdir -p "$out/share/xppen"
      cp -r App/usr/lib/pentablet/conf "$out/share/xppen/"
      cp -r App/usr/share/{applications,icons} "$out/share/"
      install -Dm644 App/lib/udev/rules.d/10-xp-pen.rules \
        "$out/lib/udev/rules.d/10-xp-pen.rules"

      # Keep string lengths unchanged: Qt also reads these with explicit lengths.
      # Repeated slashes preserve valid relative paths without embedded NULs.
      # The launcher sets the working directory to the user's config directory.
      python3 - "$out/lib/pentablet/PenTablet" <<'PY'
      import pathlib
      import sys

      path = pathlib.Path(sys.argv[1])
      data = path.read_bytes()
      for suffix in ("/config.xml", ""):
          old = ("/usr/lib/pentablet/conf/xppen" + suffix).encode() + b"\0"
          new = ("./conf/xppen" + suffix).encode() + b"\0"
          new = b"./" + b"/" * (len(old) - len(new)) + new[2:]
          if len(new) != len(old):
              raise SystemExit("Config path replacement must preserve its length")
          if data.count(old) != 1:
              raise SystemExit(f"Expected exactly one config path: {old!r}")
          data = data.replace(old, new)
      path.write_bytes(data)
      PY

      install -m755 ${./xppen.sh} "$out/bin/xppen"
      substituteInPlace "$out/bin/xppen" \
        --replace-fail '@bash@' '${stdenv.shell}' \
        --replace-fail '@coreutils@' '${coreutils}' \
        --replace-fail '@dataDir@' "$out/share/xppen" \
        --replace-fail '@program@' "$out/lib/pentablet/PenTablet"
      ln -s xppen "$out/bin/PenTablet"

      substituteInPlace "$out/share/applications/xppentablet.desktop" \
        --replace-fail '/usr/lib/pentablet/PenTablet.sh' "$out/bin/xppen" \
        --replace-fail '/usr/share/icons/hicolor/256x256/apps/xppentablet.png' 'xppentablet' \
        --replace-fail 'Categories=Application;Utility;' 'Categories=Utility;'

      runHook postInstall
    '';

    postFixup = ''
      wrapQtApp "$out/lib/pentablet/PenTablet"
    '';

    passthru.updateScript = ./update.sh;

    meta = {
      description = "Official XPPen tablet driver, including support for Deco MW";
      homepage = "https://www.xp-pen.com/";
      downloadPage = "https://www.xp-pen.com/download/deco-mw.html";
      license = lib.licenses.unfree;
      sourceProvenance = [lib.sourceTypes.binaryNativeCode];
      platforms = ["x86_64-linux"];
      mainProgram = "xppen";
    };
  }
