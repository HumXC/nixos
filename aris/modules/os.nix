{ importOs, ... }: {
  imports = importOs [
    ./clash
    ./hyprland
    ./zsh
    ./easyeffects
  ];
}
