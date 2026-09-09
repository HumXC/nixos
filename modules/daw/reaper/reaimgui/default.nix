{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  cairo,
  fontconfig,
  gtk3,
  libepoxy,
}: let
  sources = import ./sources.nix;
in
  stdenv.mkDerivation {
    pname = "reaper-reaimgui";

    inherit (sources) version;

    src = fetchurl sources.plugin;

    imguiLua = fetchurl sources.imguiLua;
    imguiPy = fetchurl sources.imguiPy;
    gfx2imguiLua = fetchurl sources.gfx2imguiLua;

    dontUnpack = true;

    nativeBuildInputs = [
      autoPatchelfHook
    ];

    buildInputs = [
      cairo
      fontconfig
      gtk3
      libepoxy
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p \
        "$out/UserPlugins" \
        "$out/Scripts/ReaTeam Extensions/API"

      cp "$src" \
        "$out/UserPlugins/reaper_imgui-x86_64.so"

      cp "$imguiLua" \
        "$out/Scripts/ReaTeam Extensions/API/imgui.lua"

      cp "$imguiPy" \
        "$out/Scripts/ReaTeam Extensions/API/imgui.py"

      cp "$gfx2imguiLua" \
        "$out/Scripts/ReaTeam Extensions/API/gfx2imgui.lua"

      runHook postInstall
    '';

    meta = {
      description = "ReaScript binding and REAPER backend for Dear ImGui";
      homepage = "https://codeberg.org/cfillion/reaimgui";
      license = lib.licenses.lgpl3Plus;
      platforms = ["x86_64-linux"];
    };
  }
