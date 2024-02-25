{ config, lib, pkgs, os, ... }:
with pkgs; let
  hideDesktopEntry = { name = "HiddenEntry"; noDisplay = true; };
  userName = os.userName;
in
{
  xresources.properties = {
    # 设置 xwayland 窗口的 dpi
    "Xft.dpi" = builtins.floor (builtins.mul os.desktop.theme.scaleFactor 100);
  };
  home.packages = (with pkgs; [
    xdg-utils
    qq
    gnome.nautilus
    easyeffects
    ark
    vscode
    telegram-desktop
    protobuf
    krita
    mpv
    swaynotificationcenter
  ]) ++ (with config.nur.repos;[
    ruixi-rebirth.go-musicfox
    humxc.hmcl-bin
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
  # 隐藏图标，我不会写函数
  xdg.desktopEntries."org.fcitx.Fcitx5" = hideDesktopEntry;
  xdg.desktopEntries."org.fcitx.fcitx5-migrator" = hideDesktopEntry;
  xdg.desktopEntries."kbd-layout-viewer5" = hideDesktopEntry;
  xdg.desktopEntries."nixos-manual" = hideDesktopEntry;
  xdg.desktopEntries."org.kde.ark" = hideDesktopEntry;
  xdg.desktopEntries."fcitx5-configtool" = hideDesktopEntry;
  xdg.desktopEntries."kcm_fcitx5" = hideDesktopEntry;
  xdg.desktopEntries."rofi" = hideDesktopEntry;
  xdg.desktopEntries."rofi-theme-selector" = hideDesktopEntry;
}
