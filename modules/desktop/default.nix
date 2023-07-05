{pkgs, ...}:
{
  imports = [
    ./hyprland
    ./waybar
    ./rofi
    ./dunst
  ];
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [ fcitx5-rime fcitx5-chinese-addons fcitx5-table-extra ];
  };
  services.gnome.gnome-keyring.enable = true; # vscode 依赖
  environment.sessionVariables.NIXOS_OZONE_WL = "";
} 