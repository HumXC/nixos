{ importHomes, ... }: {
  imports = importHomes [
    ./mpd
    ./hyprland
    ./zsh
    ./waybar
    ./kitty
    ./fcitx5
    ./helix
  ];
}
