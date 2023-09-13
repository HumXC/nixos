{lib, config, importHm, ...}:
let 
  setEnable = arr: builtins.listToAttrs (map (name: { inherit name; value = { enable = true; }; }) arr);
in {
  options.os.desktop = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable desktop.";
    };
    scale = lib.mkOption {
      type = lib.types.str;
      default = "1";
      description = "Scale factor.";
    };
  };

  config = lib.mkIf config.os.desktop.enable {
    home-manager = (importHm ./home.nix).home-manager;
    services.gnome.gnome-keyring.enable = true; # vscode 依赖
    environment.sessionVariables.NIXOS_OZONE_WL = ""; # 取消默认使用 wayland，因为 vscode 还存在 fcitx5 无法输入的问题
    # OneDrive
    services.onedrive.enable = true;
    os.programs = setEnable [
      "dunst"
      "fcitx5"
      "helix"
      "hyprland"
      "kitty"
      "lemurs"
      "mpd"
      "rofi"
      "waybar"
      "zsh"
    ];
  };
}