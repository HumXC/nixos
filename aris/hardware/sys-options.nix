{ importSysOptions, ... }: {
  hardware = importSysOptions [
    ./bluetooth
  ];
}
