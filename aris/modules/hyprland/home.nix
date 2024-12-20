{ config, lib, pkgs, pkgs-stable, getAris, nixosConfig, inputs, ... }:
let
  aris = (getAris config);
  cfg = aris.modules.hyprland;
  var =
    let e = cfg.var;
    in lib.attrsets.listToAttrs (map (key: { name = "\$${key}"; value = e."${key}"; }) (builtins.attrNames e));
in
{
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      systemd.enable = true;
      package = pkgs-stable.hyprland;
      enable = true;
      xwayland.enable = nixosConfig.programs.hyprland.xwayland.enable;
    };
    home.packages = with pkgs;
      [
        pulseaudio
        libnotify
        hyprpicker
        swww
        # 剪贴板功能
        wl-clipboard
        wf-recorder
        cliphist
        wl-clip-persist
        # 截图功能
        grim
        slurp
        swappy
      ];
    systemd.user.services.swww = {
      Unit = {
        Description = "Swww daemon";
        Wants = [ "hyprland-session.target" ];
        After = [ "hyprland-session.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.swww}/bin/swww-daemon";
        ExecStop = "${pkgs.swww}/bin/swww kill";
      };
      Install.WantedBy = [ "hyprland-session.target" ];
    };
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
          map
            (c: import c {
              inherit config pkgs lib aris;
            })
            confs
        );
      in
      var //
      importConf [
        ./hypr/hyprland.nix
        ./hypr/main.nix
        ./hypr/window-rule.nix
        ./hypr/bind.nix
      ];
  };

}
