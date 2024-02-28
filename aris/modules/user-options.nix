{ importUserOptions, ... }: {
  modules = importUserOptions [
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
