{ importSysOptions, ... }: {
  imports = importSysOptions [
    ./sddm
    ./clash
  ];
}
