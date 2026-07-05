{ lib
, stdenvNoCC
, fetchurl
, autoPatchelfHook
}:

let
  sources = import ./sources.nix { inherit fetchurl; };

  platform = stdenvNoCC.hostPlatform.system;
  source = sources.${platform} or (throw "Unsupported platform: ${platform}");

in stdenvNoCC.mkDerivation {
  pname = "lightpanda";
  inherit (source) version src;

  nativeBuildInputs = [ autoPatchelfHook ];

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -m755 $src $out/bin/lightpanda
    runHook postInstall
  '';

  meta = with lib; {
    description = "Headless browser designed for AI agents and automation";
    longDescription = ''
      Lightpanda is a headless browser optimized for AI agents, testing, and
      web scraping at scale. It provides JavaScript execution, dynamic content
      handling, Chrome DevTools Protocol support, and WebSocket connectivity.
    '';
    homepage = "https://github.com/lightpanda-io/browser";
    license = licenses.agpl3Only;
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    mainProgram = "lightpanda";
  };
}
