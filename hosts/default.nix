{ system, self, nixpkgs, inputs, ... }:
let
  lib = nixpkgs.lib;
in
{
  laptop = lib.nixosSystem {
    # Laptop profile
    inherit system;
    # profilename 是这个配置的名称，此处的 laptop 就是向上数 3 行的那个 laptop
    # 在此处添加的参数还需要在对应 profile 文件夹的 default.nix 的 home-manager.extraSpecialArgs
    specialArgs = { inherit inputs nixpkgs system; 
      profilename = "laptop"; 
      username="humxc";
      scale="1.25"; # 屏幕缩放
    };
    modules = [
      ./system.nix
      ./laptop
      ]++[
      inputs.nix-ld.nixosModules.nix-ld
      {programs.nix-ld.dev.enable = true;}
      inputs.nur.nixosModules.nur
      inputs.hyprland.nixosModules.default
      inputs.home-manager.nixosModules.home-manager
    ];
  };
} 