{ importConfig, ... }: {
  imports = importConfig [
    ./sddm
    ./clash
  ];
}
