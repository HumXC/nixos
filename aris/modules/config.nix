{ importConfigs, ... }: {
  imports = importConfigs [
    ./sddm
    ./clash
    ./hyprland
  ];
}
