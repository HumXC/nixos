{ importUser, ... }: {
  imports = importUser [
    ./mpd
    ./hyprland
    ./zsh
    ./kitty
    ./fcitx5
    ./helix
  ];
}
