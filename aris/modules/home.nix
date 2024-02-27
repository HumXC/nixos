{ importHomes, ... }: {
  imports = importHomes [
    ./mpd
    ./hyprland
  ];
}
