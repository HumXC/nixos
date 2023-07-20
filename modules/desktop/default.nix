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
  ];
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [ fcitx5-rime fcitx5-chinese-addons fcitx5-table-extra ];
  };
  services.gnome.gnome-keyring.enable = true; # vscode 依赖
  services.gvfs.enable = true; # gnome.nautilus 包的回收站功能需要 See: https://github.com/NixOS/nixpkgs/issues/140860#issuecomment-942769882
  environment.sessionVariables.NIXOS_OZONE_WL = ""; # 取消默认使用 wayland，因为 vscode 还存在 fcitx5 无法输入的问题
}