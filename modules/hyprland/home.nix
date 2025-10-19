{
  config,
  lib,
  pkgs,
  nixosConfig,
  ...
}: let
  cfg = config.aris.hyprland;
  var = let
    e = cfg.var;
  in
    lib.attrsets.listToAttrs (map (key: {
      name = "\$${key}";
      value = e."${key}";
    }) (builtins.attrNames e));
in {
  options.aris.hyprland = {
    enable = lib.mkEnableOption "hyprland";
    var = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {};
    };
    enableBlurAndOpacity = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
  };
  config = lib.mkIf cfg.enable {
    xdg.portal.config.common.default = "hyprland";
    services.hypridle.enable = true;
    services.hypridle.settings = {
      general = {
        after_sleep_cmd = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
        lock_cmd = "astal lockscreen";
      };

      listener = [
        {
          timeout = 330;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 3600;
          on-timeout = "systemctl suspend";
        }
      ];
    };
    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = true;
      package = null;
      portalPackage = pkgs.unstable.xdg-desktop-portal-hyprland;
    };
    home.packages = with pkgs; [
      libnotify
      hyprpicker
      # 剪贴板功能
      wl-clipboard
      wf-recorder
      cliphist
      wl-clip-persist
      # 截图功能
      grim
      slurp
      swappy
      unstable.hyprprop
    ];
    xdg.configFile."hypr/scripts" = {
      source = ./hypr/scripts;
      recursive = true; # 递归整个文件夹
      executable = true; # 将其中所有文件添加「执行」权限
    };

    # BUG 如果 monitor scale 不为整数 并且使用支持的分数 例如 1.2 1.5
    # 会导致鼠标光标的大小在 waybar(gtk) 和 hyprland 之间变化
    wayland.windowManager.hyprland.settings = let
      importConf = confs:
        lib.attrsets.mergeAttrsList (
          map
          (c:
            import c {
              inherit config pkgs lib;
            })
          confs
        );
    in
      var
      // importConf [
        ./hypr/hyprland.nix
        ./hypr/main.nix
        ./hypr/window-rule.nix
        ./hypr/bind.nix
      ];
  };
}
