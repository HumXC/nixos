{ importConfigs, ... }: {
  imports = importConfigs [
    ./sddm
    ./clash
  ];
}
