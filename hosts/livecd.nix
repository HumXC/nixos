{
  inputs,
  outputs,
  ...
}:
inputs.nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    ({
      pkgs,
      modulesPath,
      lib,
      ...
    }: {
      imports = [
        (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
      ];

      environment.systemPackages = with pkgs; [
        efibootmgr
        pciutils
        usbutils
        helix
        ethtool
        neofetch
        efivar
        flashrom
        nmap
        btop
        curl
        wget
        git
        htop
        net-tools
        openssh
      ];

      users.users.nixos.password = "nixos";
      users.users.nixos.initialHashedPassword = lib.mkForce null;
      networking = {
        hostName = "livecd";
        networkmanager.enable = true;
        wireless.enable = false; # 确保不与 networkmanager 冲突
      };
      services.openssh = {
        enable = true;
        settings.PasswordAuthentication = true;
      };

      systemd.services.sshd.wantedBy = lib.mkForce ["multi-user.target"];

      networking.firewall.enable = false;

      boot.kernelParams = [
        "iomem=relaxed"
      ];
    })
  ];
}
