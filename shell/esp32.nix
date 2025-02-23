{
  inputs,
  system,
  pkgs,
  ...
}:
pkgs.mkShell {
  buildInputs = [
    inputs.nixpkgs-esp-dev.packages.${system}.esp-idf-esp32
  ];
}
