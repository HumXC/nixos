{ importUser, ... }: {
  imports = importUser [
    ./mpd
    ./hyprland
    ./zsh
    ./waybar
    ./kitty
    ./fcitx5
    ./helix
  ];
}
