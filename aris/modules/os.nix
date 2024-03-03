{ importOs, ... }: {
  imports = importOs [
    ./sddm
    ./clash
    ./hyprland
    ./zsh
  ];
}
