{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  gtk3,
}: let
  source = import ./sources.nix;
in
  stdenv.mkDerivation (finalAttrs: {
    pname = "reaper-js-reascriptapi";
    version = source.version;

    src = fetchurl {
      url = source.plugin.url;
      hash = source.plugin.hash;
    };

    dontUnpack = true;

    nativeBuildInputs = [
      autoPatchelfHook
    ];

    buildInputs = [
      gtk3
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/UserPlugins
      cp $src $out/UserPlugins/reaper_js_ReaScriptAPI64.so

      runHook postInstall
    '';

    meta = {
      description = "API functions for REAPER ReaScripts";
      homepage = "https://github.com/juliansader/ReaExtensions";
      license = lib.licenses.mit;
      platforms = ["x86_64-linux"];
    };
  })
