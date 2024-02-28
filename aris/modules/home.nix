{ importHomes, ... }: {
  imports = importHomes [
    ./mpd
    ./hyprland
    ./zsh
    ./waybar
    ./rofi
    ./kitty
  ];
}
