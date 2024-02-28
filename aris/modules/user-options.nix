{ importUserOptions, ... }: {
  modules = importUserOptions [
    ./mpd
    ./hyprland
    ./zsh
    ./waybar
  ];
}
