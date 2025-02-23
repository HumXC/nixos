{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  hidedDesktopEntry = {
    name = "HiddenEntry";
    noDisplay = true;
  };
  hideDesktopEntry = package: entryNames: let
    names = builtins.toString (map (e: "\"" + e + "\"") entryNames);
  in
    with pkgs;
      lib.hiPrio
      (runCommand "$patched-desktop-entry-for-${package.name}" {} ''
        ${coreutils}/bin/mkdir -p $out/share/applications
        if [ -z "${names}" ]; then
          # 如果 names 为空，则隐藏所有的 .desktop 文件
          for file in ${package}/share/applications/*.desktop; do
            ${gawk}/bin/awk '/^\[/{if(flag){print "NoDisplay=true"} flag=0} /^\[Desktop Entry\]$/ { flag=1 } { print } END {if(flag) print "NoDisplay=true"}' \
            $file > $out/share/applications/$(basename $file)
          done
        else
          # 否则仅处理指定的 names 列表中的文件
          for name in ${names}; do
            ${gawk}/bin/awk '/^\[/{if(flag){print "NoDisplay=true"} flag=0} /^\[Desktop Entry\]$/ { flag=1 } { print } END {if(flag) print "NoDisplay=true"}' \
            ${package}/share/applications/$name.desktop > $out/share/applications/$name.desktop
          done
        fi
      '');
  cfg = config.aris.desktop;
in {
  options.aris.desktop = with lib; {
    enable = mkEnableOption "Enable desktop.";
    useNvidia = mkEnableOption "useNvidia";
    x11Scale = lib.mkOption {
      type = lib.types.float;
      default = 1.0;
      description = "Xwayland scale factor.";
    };
    monitor = lib.mkOption {
      type = lib.types.listOf (lib.types.submodule {
        options = {
          name = lib.mkOption {
            type = lib.types.str;
            description = "Like HDMI-A-1, eDP-1.";
          };
          size = lib.mkOption {
            type = lib.types.str;
            default = "1920x1080";
            description = "Monitor resolution, like 1920x1080.";
          };
          rate = lib.mkOption {
            type = lib.types.float;
            default = 60;
            description = "Refresh rate.";
          };
          scale = lib.mkOption {
            type = lib.types.float;
            default = 1.0;
            description = "Scale factor.";
          };
        };
      });
      default = [];
      description = "Monitor configuration list";
    };
    execOnce = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Execute commands once after the WM is initialized.";
    };
    env = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {};
      description = "env.";
    };
  };

  config = lib.mkIf cfg.enable {
    # 设置 xwayland 窗口的 dpi
    xresources.properties."Xft.dpi" = builtins.toString (cfg.x11Scale * 96);
    home.sessionVariables = let
      schema = pkgs.gsettings-desktop-schemas;
      datadir = "${schema}/share/gsettings-schemas/${schema.name}";
    in {
      GTK_USE_PORTAL = "1";
      XDG_DATA_DIRS = "${datadir}:$XDG_DATA_DIRS";
      GDK_BACKEND = "wayland";

      LANG = "zh_CN.UTF-8";
      LC_CTYPE = "zh_CN.UTF-8";

      GST_PLUGIN_SYSTEM_PATH_1_0 = lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" [
        pkgs.gst_all_1.gst-plugins-good
        pkgs.gst_all_1.gst-plugins-bad
        pkgs.gst_all_1.gst-plugins-ugly
        pkgs.gst_all_1.gst-libav
      ];
    };
    home.packages =
      (with pkgs; [
        glib
        xdg-utils
        nautilus
        gst_all_1.gst-plugins-ugly
        gst_all_1.gst-plugins-good
        gst_all_1.gst-plugins-bad
        gst_all_1.gst-libav
        sushi
        easyeffects
        ark
        seahorse
      ])
      ++ (with pkgs; [
        (hideDesktopEntry pkgs.unstable.fcitx5-with-addons [
          "org.fcitx.Fcitx5"
          "org.fcitx.fcitx5-migrator"
          "fcitx5-configtool"
          "kcm_fcitx5"
          "kbd-layout-viewer5"
        ])
      ])
      ++ [
        inputs.zen-browser.packages.x86_64-linux.default
      ];
    # xdg-mime query filetype filename
    # xdg-mime query default type
    xdg.mimeApps = {
      enable = true;
      associations.added = {
        "video/x-matroska" = ["mpv.desktop"];
        "text/plain" = ["code.desktop"];
        "x-scheme-handler/tg" = ["org.telegram.desktop.desktop"];
        "application/zip" = ["org.kde.ark.desktop"];
        "application/x-tar" = ["org.kde.ark.desktop"];
      };
      defaultApplications = {
        "x-scheme-handler/http" = ["google-chrome.desktop"];
        "x-scheme-handler/https" = ["google-chrome.desktop"];
        "x-scheme-handler/about" = ["google-chrome.desktop"];
        "x-scheme-handler/unknown" = ["google-chrome.desktop"];
        "x-scheme-handler/mailto" = ["google-chrome.desktop"];
        "text/html" = ["google-chrome.desktop"];
        "video/x-matroska" = ["mpv.desktop"];
        "application/json" = ["code.desktop"];
        "text/plain" = ["code.desktop"];
        "x-scheme-handler/tg" = ["org.telegram.desktop.desktop"];
        "application/zip" = ["org.kde.ark.desktop"];
        "application/x-tar" = ["org.kde.ark.desktop"];
      };
    };
    aris.vscode.enable = true;
    # 隐藏图标
    xdg.desktopEntries."nixos-manual" = hidedDesktopEntry;
  };
}
