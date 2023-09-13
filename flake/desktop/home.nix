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

  scale = os.desktop.scale;
  userName = os.userName;
in
{
  imports = [ ./theme/home.nix ];
  home.packages = (with pkgs; [
    xdg-utils
    rnix-lsp # nix 的 lsp，vscode 的 nix 扩展依赖
    qq
    gnome.nautilus
    openssl
    easyeffects
    ark
    vscode
    wl-clipboard
    cliphist # 剪贴板功能
    swww
    grim
    slurp
    swappy # 截图功能
    telegram-desktop
    go
    wails
    upx
    nodejs_20 # https://matthewrhone.dev/nixos-npm-globally
  ]) ++ (with config.nur.repos;[
    ruixi-rebirth.go-musicfox
    humxc.hmcl-bin
  ]) ++ [
    # patch desktop entry
    (patchDesktop pkgs.qq "qq" [
      "Exec=${qq}/bin/qq %U"
    ] [
      "Exec=${qq}/bin/qq --force-device-scale-factor=${scale} %U"
    ])
    (patchDesktop pkgs.vscode "code" [
      "Exec=code %F"
    ] [
      "Exec=${vscode}/bin/code --force-device-scale-factor=${scale} %F"
    ])
  ];
  programs.zsh = {
    initExtraBeforeCompInit = ''
      export PATH=$HOME/.npm-packages/bin:$PATH
      export NODE_PATH=~/.npm-packages/lib/node_modules
    '';
  };
  xdg.desktopEntries."mc" = {
    name = "Minecraft";
    icon = "minecraft";
    exec = "/home/${userName}/.mc.sh";
    comment = "Minecraft";
    categories = [ "Game" ];
  };

  programs.google-chrome = {
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
