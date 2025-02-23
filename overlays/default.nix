{inputs, ...}: {
  additions = final: _prev:
    import ../pkgs {
      nixpkgs = inputs.nixpkgs;
      system = final.system;
    };
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      inherit (final) system config;
    };
  };
}
