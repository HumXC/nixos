{ config, lib, pkgs, os, ... }:
let
  userName = os.userName;
  execOnce = pkgs.lib.concatStrings (builtins.map (x: "exec-once = " + x + "\n") config.aris.desktop.execOnce);
  env =
    let e = os.programs.hyprland.env;
    in lib.attrsets.listToAttrs (map (key: { name = "\$${key}"; value = e."${key}"; }) (builtins.attrNames e));
in
{
  wayland.windowManager.hyprland.enable = true;
  home.packages = with pkgs;
    [
      hyprpicker
      swww
      # 剪贴板功能
      wl-clipboard
      cliphist
      wl-clip-persist
      # 截图功能
      grim
      slurp
      swappy
    ];

  xdg.configFile."hypr/scripts" = {
    source = ./hypr/scripts;
    recursive = true; # 递归整个文件夹
    executable = true; # 将其中所有文件添加「执行」权限
  };

  # BUG 如果 monitor scale 不为整数 并且使用支持的分数 例如 1.2 1.5
  # 会导致鼠标光标的大小在 waybar(gtk) 和 hyprland 之间变化
  wayland.windowManager.hyprland.settings =
    let
      importConf = confs: lib.attrsets.mergeAttrsList (
        map (c: import c { inherit config pkgs lib; }) confs
      );
    in
    env // importConf [
      ./hypr/hyprland.nix
      ./hypr/main.nix
      ./hypr/window-rule.nix
      ./hypr/bind.nix
    ];
}
