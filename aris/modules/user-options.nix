{ importUserOptions, ... }: {
  modules = importUserOptions [
    ./mpd
  ];
}
