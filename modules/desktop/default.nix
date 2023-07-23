{pkgs, ...}:
{
  imports = [
    ./theme
    ../programs/hyprland
    ../programs/waybar
    ../programs/rofi
    ../programs/dunst
    ../programs/kitty
    ../programs/clash-premium
    ../programs/zsh
    ../programs/helix
    ../programs/fcitx5
    ../programs/mpd
  ];
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  services.gnome.gnome-keyring.enable = true; # vscode 依赖
  environment.sessionVariables.NIXOS_OZONE_WL = ""; # 取消默认使用 wayland，因为 vscode 还存在 fcitx5 无法输入的问题
}