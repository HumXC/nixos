{ importUserOptions, ... }: {
  modules = importUserOptions [
    ./mpd
    ./hyprland
  ];
}