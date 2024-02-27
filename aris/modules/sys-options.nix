{ importSysOptions, ... }: {
  modules = importSysOptions [
    ./sddm
    ./clash
  ];
}
