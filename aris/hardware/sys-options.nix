{ importSysOptions, ... }: {
  hardware = importSysOptions [
    ./bluetooth
  ];
}