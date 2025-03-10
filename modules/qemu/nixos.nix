{pkgs}: let
  # No Testing yet
  virtualMachineName = "Windows";
  pciIDs = [
    "03:00.0"
    "04:00.0"
  ];

  virshCommand = action: builtins.concatStringsSep "\n" (map (pciID: "virsh ${action} pci_0000_${builtins.replaceStrings [":" "."] ["_" "_"] pciID}") pciIDs);
  gpu-unbind = pkgs.writeScriptBin "qemu-hook-gpu-unbind.sh" ''
    set -x
    rmmod -f i915

    sleep 2

    ${virshCommand "nodedev-detach"}

    modprobe vfio-pci
  '';
  gpu-resume = pkgs.writeScriptBin "qemu-hook-gpu-resum.sh" ''
    set -x

    modprobe -r vfio_pci

    ${virshCommand "nodedev-reattach"}

    modprobe i915
  '';
  systemd-nosleep = pkgs.writeScriptBin "qemu-hook-systemd-nosleep.sh" ''
    systemctl start libvirt-nosleep@${virtualMachineName}
  '';
  systemd-cansleep = pkgs.writeScriptBin "qemu-hook-systemd-cansleep.sh" ''
    systemctl stop libvirt-nosleep@${virtualMachineName}
  '';
in {
  # JUST debug
  services.openssh = {
    enable = true;
    settings = {
      ClientAliveInterval = 60;
      ClientAliveCountMax = 3;
      PasswordAuthentication = true;
      KbdInteractiveAuthentication = false;
      Macs = ["hmac-sha1" "hmac-md5"];
    };
  };
  systemd.services."libvirt-nosleep@" = {
    description = ''Preventing sleep while libvirt domain "%i" is running'';
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "simple";
      ExecStart = ''
        ${pkgs.systemd}/bin/systemd-inhibit --what=sleep --why="Libvirt domain ''${VIRSH_DOMAIN} is running" --who=$USER --mode=block sleep infinity
      '';
    };
  };
  # 03:00.0 VGA compatible controller [0300]: Intel Corporation DG2 [Arc A770] [8086:56a0] (rev 08)
  # 04:00.0 Audio device [0403]: Intel Corporation DG2 Audio Controller [8086:4f90]
  virtualisation.libvirtd.hooks.qemu = let
  in {
    # ${virtualMachineName} = {
    #   prepare."10-gpu-unbind.sh" = ./gpu-unbind.sh;
    #   prepare."11-nosleep.sh" = ./nosleep.sh;
    #   release."10-gpu-resume.sh" = ./gpu-resum.sh;
    #   release."11-cansleep.sh" =./cansleep.sh;
    # };
  };

  environment.systemPackages = [
    (pkgs.writeScriptBin "Windows" ''
      # 检查是否为root权限
      if [ "$(id -u)" -ne 0 ]; then
          echo "错误: 该脚本需要以 root 用户运行！" >&2
          exit 1
      fi

      # 检查是否有名称为 "Windows" 的虚拟机
      VM_NAME="Windows"
      VM_STATUS=$(virsh list --state-running --name | grep -w "$VM_NAME")

      echo $VM_STATUS
      if [ -n "$VM_STATUS" ]; then
          echo "错误: 虚拟机 '$VM_NAME' 已经在运行中！" >&2
          echo "如果你希望关闭该虚拟机，可以运行以下命令："
          echo "  virsh shutdown '$VM_NAME'"
          exit 1
      fi

      # 检查虚拟机是否存在
      if ! virsh list --all --name | grep -w "$VM_NAME" > /dev/null; then
          echo "错误: 虚拟机 '$VM_NAME' 不存在！" >&2
          exit 1
      fi

      # 启动虚拟机
      echo "启动虚拟机 '$VM_NAME' ..."
      virsh start "$VM_NAME"
      if [ $? -eq 0 ]; then
          echo "虚拟机 '$VM_NAME' 启动成功！"
      else
          echo "错误: 无法启动虚拟机 '$VM_NAME'！" >&2
          exit 1
      fi
    '')
    gpu-unbind
    gpu-resume
    systemd-nosleep
    systemd-cansleep
  ];
  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = ["HumXC"];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
}
