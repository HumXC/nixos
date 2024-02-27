{ config, lib, pkgs, ... }@args:
with pkgs; let
  hidedDesktopEntry = { name = "HiddenEntry"; noDisplay = true; };
  userName = os.userName;
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
in
{
  config = lib.mkIf config.aris.desktop.enable {
    aris.desktop.execOnce = [
      # 解决部分窗口中，鼠标指针显示为 “X” 的情况 https://wiki.archlinuxcn.org/wiki/%E5%85%89%E6%A0%87%E4%B8%BB%E9%A2%98#%E6%9B%B4%E6%94%B9%E9%BB%98%E8%AE%A4_X_%E5%BD%A2%E5%85%89%E6%A0%87
      "${xdg-desktop-portal-gtk}/libexec/xdg-desktop-portal-gtk"
      "${xorg.xsetroot}/bin/xsetroot -cursor_name left_ptr"
      "${xorg.xrandr}/bin/xrandr;${builtins.replaceStrings [ "\n" ] [ ";" ] config.xsession.initExtra}"
      "${polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
      "${swaynotificationcenter}/bin/swaync"
      "${waybar}/bin/waybar"
    ];
    xresources.properties = {
      # 设置 xwayland 窗口的 dpi
      "Xft.dpi" = builtins.floor (builtins.mul config.aris.desktop.theme.scaleFactor 100);
    };

    home.sessionVariables =
      let
        scale = toString config.aris.desktop.theme.scaleFactor;
        schema = pkgs.gsettings-desktop-schemas;
        datadir = "${schema}/share/gsettings-schemas/${schema.name}";
      in
      {
        GTK_USE_PORTAL = "1";
        XDG_DATA_DIRS = "${datadir}:$XDG_DATA_DIRS";
        GDK_DPI_SCALE = scale;
        QT_SCALE_FACTOR = scale;
      };

    home.packages = (with pkgs; [
      glib
      xdg-utils
      gnome.nautilus
      easyeffects
      vscode
      swaynotificationcenter
    ]) ++ (with config.nur.repos;[
      ruixi-rebirth.go-musicfox
      humxc.hmcl-bin
    ]) ++ (with pkgs; [
      (hideDesktopEntry ark [ "org.kde.ark" ])
      (hideDesktopEntry fcitx5-with-addons [
        "org.fcitx.Fcitx5"
        "org.fcitx.fcitx5-migrator"
        "fcitx5-configtool"
        "kcm_fcitx5"
        "kbd-layout-viewer5"
      ])
    ]);
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

    programs.brave = {
      enable = true;
      commandLineArgs = [ "--ozone-platform=wayland" "--ozone-platform-hint=auto" "--enable-wayland-ime" ];
    };
    # 隐藏图标
    xdg.desktopEntries."nixos-manual" = hidedDesktopEntry;
  };
}

