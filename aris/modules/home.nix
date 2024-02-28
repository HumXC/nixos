{ importHomes, ... }: {
  imports = importHomes [
    ./mpd
    ./hyprland
    ./zsh
  ];
}
