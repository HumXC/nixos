{
  pkgs,
  config,
  lib,
  nixosConfig,
  ...
}: let
  cfg = config.aris.fish;
  profileName = nixosConfig.aris.profileName;
  waydroidEnabled = nixosConfig.virtualisation.waydroid.enable;
  starshipConfig = builtins.fromTOML (builtins.readFile ./starship.toml);
in {
  options.aris.fish.enable = lib.mkEnableOption "fish";
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [zoxide eza];
    programs.starship = {
      enable = true;
      settings =
        starshipConfig
        // {
          add_newline = false;
          character = {
            success_symbol = "[➜](bold green)";
            error_symbol = "[➜](bold red)";
          };
        };
    };
    programs.fish = {
      enable = true;
      functions = {
        fish_greeting = let
          type =
            if config.aris.desktop.enable
            then "desktop"
            else "server";
        in ''
          set type ${type}
          set host (hostname)
          switch $type
            case "desktop"
                echo -e "  $host!"
            case "server"
                echo -e "  $host！"
          end
        '';
        os-edit = "$OS_EDITOR /etc/nixos";
        os-update = ''
          set pwd (pwd)
          cd /etc/nixos
          set now (date "+%Y-%m-%d-%T")
          cp flake.lock backup/$now
          doas nix flake update
          cd "$pwd"
        '';
        os-build = ''
          # https://github.com/NixOS/nix/issues/10202
          doas git config --global --add safe.directory /etc/nixos
          nh os switch -H ${profileName} $argv
        '';
        os-build-dry = ''
          doas git config --global --add safe.directory /etc/nixos
          nh os build --dry -H ${profileName} $argv
        '';
        os-rollback = ''
          set backup_dir "/etc/nixos/backup"

          if not test -d "$backup_dir"
              echo "Error: backup directory does not exist."
              return 1
          end

          switch $argv[1]
              case list
                  # 列出按时间排序的文件，并添加行号
                  ls -1t "$backup_dir" | nl -n ln -w 2 -s " - "
              case ""
                  # 获取最新的文件
                  set latest_file (ls -1t "$backup_dir" | head -n 1)
                  if test -n "$latest_file"
                      # 备份当前 flake.lock 并恢复
                      set now (date "+%Y-%m-%d-%T")
                      cp /etc/nixos/flake.lock "/etc/nixos/backup/$now"
                      cp "$backup_dir/$latest_file" /etc/nixos/flake.lock
                      echo "Rollback $latest_file"
                  else
                      echo "No files found to rollback."
                  end
              case "[0-9]*"
                  # 通过序号恢复对应的文件
                  set file (ls -1t "$backup_dir" | sed -n ""$argv[1]"p")
                  if test -n "$file"
                      set now (date "+%Y-%m-%d-%T")
                      cp /etc/nixos/flake.lock "/etc/nixos/backup/$now"
                      cp "$backup_dir/$file" /etc/nixos/flake.lock
                      echo "Rollback $file"
                  else
                      echo "No file found for number $argv[1]."
                  end
              case '*'
                  echo "Invalid argument. Usage: os-rollback [list|<number>]"
          end
        '';
        nix-callpkg = ''
          if test (count $argv) -ne 1
            echo "Usage: nix-callpkg <path-to-package>"
            echo "Tip: Don't forget to prepend \"./\" if <path-to-package> is a local file."
            echo "Origin: nix-build -E \"with import <nixpkgs> {}; callPackage path-to-package {}\""
            return 1
          end
          set args "{}"
          if test -f "$argv[2]"
            set args "$argv[2]"
          end
          nix-build -E "with import <nixpkgs> {}; callPackage $argv[1] $args"
        '';
        list-applications = ''
          set -l dirs (string split ":" $XDG_DATA_DIRS)
          # 遍历每个路径
          for dir in $dirs
              # 构建 applications 子目录的路径
              set app_dir "$dir/applications"
              # 检查 applications 子目录是否存在
              if test -d "$app_dir"
                  echo "Listing applications folder in $dir:"
                  ls -l "$app_dir"
              else
                  echo "Applications folder not found in $dir"
              end
          end
        '';
        mime-type = ''
          xdg-mime query filetype $argv
        '';
        mime-default = ''
          xdg-mime query default (mime-type $argv)
        '';
        no-proxy = ''
          set -gx all_proxy ""
          set -gx http_proxy ""
          set -gx https_proxy ""
        '';

        waydroid-settings = lib.mkIf waydroidEnabled ''
          waydroid prop set persist.waydroid.multi_windows false
          waydroid prop set persist.waydroid.cursor_on_subsurface false
          waydroid prop set persist.waydroid.height 0
          waydroid prop set persist.waydroid.width 0
        '';
        waydroid-hide-desktops = lib.mkIf waydroidEnabled ''
          set dir "$HOME/.local/share/applications"
          if not test -d "$dir"
              echo "Directory $dir not found."
              return 1
          end
          # 遍历指定目录下的以 waydroid. 开头的文件, 排除 waydroid.desktop
          for file in $dir/waydroid.*
              if test -f "$file" && test "$file" != "$dir/waydroid.desktop"
                  if not grep -q 'NoDisplay=true' "$file"
                      sed -i '/^\[Desktop Entry\]$/a NoDisplay=true' "$file"
                  end
              end
          end
        '';
      };
      shellAbbrs = {};
      shellInit = ''
        set -gx PATH $HOME/go/bin:$PATH
        set -gx PATH $HOME/.npm-packages/bin:$PATH
        set -gx NODE_PATH ~/.npm-packages/lib/node_modules
        set -gx PNPM_HOME ~/.npm-packages/pnpm
        set -gx PATH $PNPM_HOME:$PATH
        zoxide init fish | source
      '';
      shellAliases = {
        ls = "eza --icons";
        ll = "eza --icons -l";
        la = "eza --icons -la";
        icat = "kitty +kitten icat";
        Tp = "trash put";
        Tl = "trash list";
      };
    };
  };
}
