{inputs, ...}: {
  system = "x86_64-linux";
  extraModules = [
    # https://www.nyx.chaotic.cx/
    inputs.chaotic.nixosModules.nyx-cache
    inputs.chaotic.nixosModules.nyx-overlay
    inputs.chaotic.nixosModules.nyx-registry
  ];
  extraSpecialArgs = {};
  hostName = "Aika";
}
