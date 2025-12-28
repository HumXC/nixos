{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.aris.daw;
  patchScript = packages: plugin: let
    so = "${config.xdg.configHome}/REAPER/UserPlugins/${plugin}.so";
  in {
    executable = true;
    text = ''
      #! /usr/bin/env bash
      nix-shell -p ${lib.concatStringsSep " " packages} autoPatchelfHook --run "autoPatchelf ${so}"
      chmod +x ${so}
    '';
  };
in {
  options.aris.daw = {
    enable = lib.mkEnableOption "daw";
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs.unstable; [
      (symlinkJoin {
        name = "Reaper";
        paths = [reaper];
        inherit (reaper) meta;
        buildInputs = [
          makeWrapper
        ];
        postBuild = ''
          rm $out/share/applications/cockos-reaper.desktop
          cp ${reaper}/share/applications/cockos-reaper.desktop $out/share/applications/cockos-reaper.desktop
          substituteInPlace $out/share/applications/cockos-reaper.desktop \
            --replace-fail "Exec=reaper %F" "Exec=env GDK_BACKEND=x11 reaper %F"
        '';
      })
      yabridge
      yabridgectl
      helvum
      noise-repellent
      vital
      yoshimi
      (pkgs.lib.hideDesktopEntry lsp-plugins [])
    ];

    xdg.configFile."fontconfig/conf.d/60-reaper-fallback-chinese.conf".text = ''
      <?xml version="1.0"?>
        <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
        <fontconfig>
          <!-- REAPER fonts patch -->
          <match target="pattern">
            <test name="prgname">
              <string>.reaper-wrapped</string>
            </test>
            <edit name="family" mode="assign">
              <string>MiSans</string>
            </edit>
          </match>
        </fontconfig>
    '';
    xdg.configFile."REAPER" = {
      source = pkgs.symlinkJoin {
        name = "reaper-userplugins";
        paths = with pkgs; [
          reaper-sws-extension
          reaper-reapack-extension
        ];
      };
      recursive = true;
    };
    # https://github.com/Ubunteous/NixOS-System/blob/master/pkgs/reaimgui/auto_fetch.sh
    xdg.configFile."REAPER/nixos-support/patch-reaimgui" = patchScript ["cairo" "libepoxy" "gtk3"] "reaper_imgui-x86_64";
    xdg.configFile."REAPER/nixos-support/patch-reaper-js" = patchScript ["gtk3"] "reaper_js_ReaScriptAPI64";
  };
}
