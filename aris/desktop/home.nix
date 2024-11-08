{ config, lib, pkgs, pkgs-unstable, getAris, inputs, ... }:
let
  hidedDesktopEntry = { name = "HiddenEntry"; noDisplay = true; };
  hideDesktopEntry = package: entryNames:
    let
      names = (builtins.toString (map (e: "\"" + e + "\"") entryNames));
    in
    with pkgs;
    lib.hiPrio
      (runCommand "$patched-desktop-entry-for-${package.name}" { } ''
        ${coreutils}/bin/mkdir -p $out/share/applications
        for name in ${names}; do
          # ${gnused}/bin/sed -e '/^\[Desktop Entry\]$/a NoDisplay=true' \
          # 查找 [Desktop Entry], 然后搜索文件末尾或者以 "[" 开头的行, 在之前添加 "NoDisplay=true"
          ${gawk}/bin/awk '/^\[/{if(flag){print "NoDisplay=true"} flag=0} /^\[Desktop Entry\]$/ { flag=1 } { print } END {if(flag) print "NoDisplay=true"}' \
          ${package}/share/applications/$name.desktop> $out/share/applications/$name.desktop
        done
      '');
  cfg = (getAris config).desktop;
in
{
  config = lib.mkIf cfg.enable {
    xresources.properties = {
      # 设置 xwayland 窗口的 dpi
      "Xft.dpi" = builtins.floor (builtins.mul cfg.theme.scaleFactor 100);
    };
    home.sessionVariables =
      let
        scale = toString cfg.theme.scaleFactor;
        schema = pkgs.gsettings-desktop-schemas;
        datadir = "${schema}/share/gsettings-schemas/${schema.name}";
      in
      {
        GTK_USE_PORTAL = "1";
        XDG_DATA_DIRS = "${datadir}:$XDG_DATA_DIRS";
        QT_SCALE_FACTOR = scale;
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
    home.packages = (with pkgs; [
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
      libsForQt5.qtstyleplugin-kvantum
    ]) ++ (with pkgs; [
      (hideDesktopEntry pkgs-unstable.fcitx5-with-addons [
        "org.fcitx.Fcitx5"
        "org.fcitx.fcitx5-migrator"
        "fcitx5-configtool"
        "kcm_fcitx5"
        "kbd-layout-viewer5"
      ])
    ]) ++ [
      inputs.zen-browser.packages.x86_64-linux.default
    ];
    # xdg-mime query filetype filename
    # xdg-mime query default type
    xdg.mimeApps = {
      enable = true;
      associations.added = {
        "video/x-matroska" = [ "mpv.desktop" ];
        "text/plain" = [ "code.desktop" ];
        "x-scheme-handler/tg" = [ "org.telegram.desktop.desktop" ];
        "application/zip" = [ "org.kde.ark.desktop" ];
        "application/x-tar" = [ "org.kde.ark.desktop" ];
      };
      defaultApplications = {
        "x-scheme-handler/http" = [ "google-chrome.desktop" ];
        "x-scheme-handler/https" = [ "google-chrome.desktop" ];
        "x-scheme-handler/about" = [ "google-chrome.desktop" ];
        "x-scheme-handler/unknown" = [ "google-chrome.desktop" ];
        "x-scheme-handler/mailto" = [ "google-chrome.desktop" ];
        "text/html" = [ "google-chrome.desktop" ];
        "video/x-matroska" = [ "mpv.desktop" ];
        "application/json" = [ "code.desktop" ];
        "text/plain" = [ "code.desktop" ];
        "x-scheme-handler/tg" = [ "org.telegram.desktop.desktop" ];
        "application/zip" = [ "org.kde.ark.desktop" ];
        "application/x-tar" = [ "org.kde.ark.desktop" ];
      };
    };

    # 隐藏图标
    xdg.desktopEntries."nixos-manual" = hidedDesktopEntry;
  };
}

