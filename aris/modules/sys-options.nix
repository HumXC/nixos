{ importSysOptions, ... }: {
  modules = importSysOptions [
    ./sddm
  ];
}
