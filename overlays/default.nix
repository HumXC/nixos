{inputs, ...}: {
  additions = final: _prev:
    import ../pkgs {
      nixpkgs = inputs.nixpkgs-unstable;
      system = final.hostPlatform.system;
    };
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      inherit (final) system config;
    };
  };
  extra-lib = final: _prev: {
    lib =
      _prev.lib
      // (import ../lib {
        pkgs = final;
      });
  };
}
