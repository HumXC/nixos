{ importHomes, ... }: {
  imports = importHomes [
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
