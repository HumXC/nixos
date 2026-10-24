{
  inputs,
  outputs,
  ...
}:
inputs.nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    ({lib, ...}: {
      # 安装镜像的基础模块会加入 Vim，仅过滤该编辑器。
      options.environment.systemPackages = lib.mkOption {
        apply = packages: lib.filter (package: lib.getName package != "vim") packages;
      };
    })
    ({
      pkgs,
      modulesPath,
      lib,
      ...
    }: {
      imports = [
        (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
      ];

      # 关闭 GNOME 默认应用集，仅保留 LiveCD 所需的桌面工具。
      services.xserver.enable = true;
      services.desktopManager.gnome = {
        enable = true;
        favoriteAppsOverride = ''
          [org.gnome.shell]
          favorite-apps=[ 'chromium-browser.desktop', 'org.gnome.Console.desktop', 'org.gnome.Nautilus.desktop', 'vrime.desktop' ]
        '';
      };
      services.gnome.core-apps.enable = false;
      environment.gnome.excludePackages = with pkgs; [
        gnome-tour
        gnome-user-docs
      ];

      # 最小安装镜像默认禁用 Fontconfig，图形桌面需要恢复字体发现与匹配。
      fonts.fontconfig.enable = true;

      services.displayManager = {
        gdm = {
          enable = true;
          autoSuspend = false;
        };
        autoLogin = {
          enable = true;
          user = "nixos";
        };
      };

      # 自动登录没有密码可交给 PAM；为临时 LiveCD 准备空密码的默认钥匙串。
      # GNOME 会在应用访问时自动解锁；已有钥匙串保留，新凭据不加密。
      systemd.services.livecd-keyring = {
        description = "Prepare the LiveCD default keyring";
        wantedBy = ["multi-user.target"];
        requiredBy = ["display-manager.service"];
        before = ["display-manager.service"];
        path = [pkgs.coreutils];
        serviceConfig = {
          Type = "oneshot";
          User = "nixos";
          UMask = "0077";
          RemainAfterExit = true;
        };
        script = ''
          keyring_dir="$HOME/.local/share/keyrings"
          mkdir -p "$keyring_dir"
          chmod 700 "$keyring_dir"

          if [ ! -e "$keyring_dir/livecd.keyring" ]; then
            cat > "$keyring_dir/livecd.keyring" <<'EOF'
          [keyring]
          display-name=LiveCD
          ctime=0
          mtime=0
          lock-on-idle=false
          lock-after=false
          lock-timeout=0
          EOF
            chmod 600 "$keyring_dir/livecd.keyring"
          fi

          if [ -e "$keyring_dir/default" ] && [ ! -e "$keyring_dir/default.before-livecd" ]; then
            cp -p "$keyring_dir/default" "$keyring_dir/default.before-livecd"
          fi
          printf '%s\n' livecd > "$keyring_dir/default"
        '';
      };

      xdg.mime.defaultApplications = {
        "text/html" = "chromium-browser.desktop";
        "x-scheme-handler/http" = "chromium-browser.desktop";
        "x-scheme-handler/https" = "chromium-browser.desktop";
        "inode/directory" = "org.gnome.Nautilus.desktop";
      };

      environment.systemPackages = with pkgs; [
        (makeDesktopItem {
          name = "vrime";
          desktopName = "VRime";
          comment = "打开 VRime 网站";
          exec = "${lib.getExe chromium} --new-window https://vrime.org/";
          icon = "input-keyboard-symbolic";
          terminal = false;
          categories = ["Network" "WebBrowser"];
        })
        chromium
        nautilus
        gnome-console
        efibootmgr
        pciutils
        usbutils
        helix
        ethtool
        fastfetch
        efivar
        flashrom
        nmap
        btop
        curl
        wget
        git
        btop
        net-tools
        openssh
        flclash
        vscode
        nodejs
      ];

      # 安装镜像中的 root 使用空密码，便于本地控制台维护。
      users.users.root.initialHashedPassword = lib.mkForce "";
      users.users.nixos.password = "nixos";
      users.users.nixos.initialHashedPassword = lib.mkForce null;
      networking = {
        hostName = "livecd";
        networkmanager.enable = true;
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
