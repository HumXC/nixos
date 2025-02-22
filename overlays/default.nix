{ inputs, ... }: {
  additions = final: _prev: import ../pkgs final.pkgs;
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      inherit (final) system;
      config = final.config;
    };
  };
}
