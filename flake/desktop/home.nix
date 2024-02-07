{ config, lib, pkgs, os, ... }:
with pkgs; let
  # From: https://www.reddit.com/r/NixOS/comments/scf0ui/comment/j3dfk27/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
  patchDesktop = pkg: appName: from: to:
    with pkgs; let
      zipped = lib.zipLists from to;
      # Multiple operations to be performed by sed are specified with -e
      sed-args = builtins.map
        ({ fst, snd }: "-e 's#${fst}#${snd}#g'")
        zipped;
      concat-args = builtins.concatStringsSep " " sed-args;
    in
    lib.hiPrio
      (pkgs.runCommand "$patched-desktop-entry-for-${appName}" { } ''
        ${coreutils}/bin/mkdir -p $out/share/applications
        ${gnused}/bin/sed ${concat-args} \
         ${pkg}/share/applications/${appName}.desktop \
         > $out/share/applications/${appName}.desktop
      '');

  userName = os.userName;
in
{
  xresources.properties = {
    # 设置 xwayland 窗口的 dpi
    "Xft.dpi" = builtins.floor (builtins.mul os.desktop.scaleFactor 100);
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

  programs.zsh = {
    initExtraBeforeCompInit = ''
      export PATH=$HOME/.npm-packages/bin:$PATH
      export NODE_PATH=~/.npm-packages/lib/node_modules
      export PNPM_HOME=~/.npm-packages/pnpm
      export PATH=$PNPM_HOME:$PATH
    '';
  };

  xdg.desktopEntries."mc" = {
    name = "Minecraft";
    icon = "minecraft";
    exec = "/home/${userName}/.mc.sh";
    comment = "Minecraft";
    categories = [ "Game" ];
  };

  programs.brave = {
    enable = true;
    commandLineArgs = [ "--ozone-platform=wayland" "--ozone-platform-hint=auto" "--enable-wayland-ime" ];
  };

  # 隐藏图标，我不会写函数
  xdg.desktopEntries."org.fcitx.Fcitx5" = {
    name = "";
    noDisplay = true;
  };
  xdg.desktopEntries."org.fcitx.fcitx5-migrator" = {
    name = "";
    noDisplay = true;
  };
  xdg.desktopEntries."kbd-layout-viewer5" = {
    name = "";
    noDisplay = true;
  };
  xdg.desktopEntries."nixos-manual" = {
    name = "";
    noDisplay = true;
  };

}
