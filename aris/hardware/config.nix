{ importConfigs, ... }: {
  imports = importConfigs [
    ./bluetooth
  ];
}