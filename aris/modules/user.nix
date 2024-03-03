{ importUser, ... }: {
  imports = importUser [
    ./mpd
    ./hyprland
    ./zsh
    ./waybar
    ./rofi
    ./kitty
    ./fcitx5
    ./helix
  ];
}
