{ importHomes, ... }: {
  imports = importHomes [
    ./mpd
    ./hyprland
    ./zsh
    ./kitty
    ./fcitx5
    ./helix
  ];
}
