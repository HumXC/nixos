{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: let
  reaper-wayland = inputs.reaper-flake.packages.${pkgs.system}.reaper.override {
    waylandSwellSupport = true;
  };
in {
  home.packages = with pkgs.unstable; [
    (symlinkJoin {
      name = "Reaper";

      paths = [
        reaper
      ];

      inherit (reaper) meta;

      buildInputs = [
        makeWrapper
      ];

      postBuild = ''
        rm $out/share/applications/cockos-reaper.desktop

        cp \
          ${reaper}/share/applications/cockos-reaper.desktop \
          $out/share/applications/cockos-reaper.desktop

        substituteInPlace \
          $out/share/applications/cockos-reaper.desktop \
          --replace-fail \
          "Exec=reaper %F" \
          "Exec=env GDK_BACKEND=x11 reaper %F"
      '';
    })
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

      paths = with pkgs;
        [
          reaper-sws-extension
          reaper-reapack-extension
        ]
        ++ [
          (pkgs.callPackage ./js-reascriptapi {})
          (pkgs.callPackage ./reaimgui {})
        ];
    };

    recursive = true;
  };
  xdg.configFile."REAPER/install-reapertips-theme.sh" = {
    source = ./install-reapertips-theme.sh;
    executable = true;
  };
}
