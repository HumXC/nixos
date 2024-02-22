{ config, lib, pkgs, os, ... }:
let
  profileName = os.profileName;
  scale = toString os.desktop.scaleFactor;
  p10kType = os.programs.zsh.p10kType;
in
{
  home.file.".p10k.zsh" = {
    source = ./.p10k-${ p10kType }.zsh;
  };
  home.packages = with pkgs; [
    fzf
    autojump
  ];
  programs.zsh = {
    enable = true;
    # 此选项与 default.nix 中的默认值重复，如果不关闭会严重拖慢启动速度
    enableCompletion = false;
    initExtraBeforeCompInit = ''
      # p10k instant prompt
      P10K_INSTANT_PROMPT="$XDG_CACHE_HOME/p10k-instant-prompt-''${(%):-%n}.zsh"
      [[ ! -r "$P10K_INSTANT_PROMPT" ]] || source "$P10K_INSTANT_PROMPT"
    '';
    initExtra = ''
      export PATH=$HOME/go/bin:$PATH
      # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

      # fzf
      if [ -n "''${commands[fzf-share]}" ]; then
        source "$(fzf-share)/key-bindings.zsh"
        source "$(fzf-share)/completion.zsh"
      fi

      # Functions
      # 禁用 rm 命令
      # function rm() {cowsay -f sodomized "Fuck rm! Use Tp (trash put)"}

      # 编辑系统
      function os-edit() {
        $OS_EDITOR /etc/nixos
      }

      # 更新系统
      function os-update() {
        pwd=$(pwd)
        cd /etc/nixos
        now=$(date +"%Y-%m-%d-%T")
        cp flake.lock backup/$now
        doas nix flake update
        cd "$pwd"
      }
    
      # 重新构建系统
      function os-build() {
        doas nixos-rebuild switch --flake /etc/nixos#${profileName}
      }

      # 尝试评估构建系统
      function os-dry-build() {
        local flake_identifier=''${1:-${profileName}}  
        doas nixos-rebuild dry-build --flake /etc/nixos#$flake_identifier
      }

      # 尝试单独构建某个包
      function nix-callpkg() {
        if [ "$#" -ne 1 ]; then
          echo "Usage: nix-callpkg <path-to-package>"
          echo "Tip: Don't forget to prepend \"./\" if <path-to-package> is a local file."
          echo "Origin: nix-build -E \"with import <nixpkgs> {}; callPackage path-to-package {}\""
          return 1
        fi

        nix-build -E "with import <nixpkgs> {}; callPackage $1 {}"
      }

      os-rollback() {
        backup_dir="/etc/nixos/backup"
    
        if [ ! -d "$backup_dir" ]; then
            echo "Error: backup directory does not exist."
            return 1
        fi
    
        case $1 in
        list)
            # 使用ls命令列出按时间排序的文件，并添加行号
            ls -1t "$backup_dir" | nl -n ln -w 2 -s " - "
            ;;
        "")
            # 获取最新的文件
            latest_file=$(ls -1t "$backup_dir" | head -n 1)
            if [ -n "$latest_file" ]; then
                # 移动最新的文件
                now=$(date +"%Y-%m-%d-%T")
                cp /etc/nixos/flake.lock /etc/nixos/backup/$now
                cp $backup_dir/$latest_file /etc/nixos/flake.lock
                echo "Rollback $latest_file"
            else
                echo "No files found to rollback."
            fi
            ;;
        [0-9]*)
            # 通过序号来覆盖对应的文件
            file=$(ls -1t "$backup_dir" | sed -n "''${1}p")
            if [ -n "$file" ]; then
                now=$(date +"%Y-%m-%d-%T")
                cp /etc/nixos/flake.lock /etc/nixos/backup/$now
                cp $backup_dir/$file /etc/nixos/flake.lock
                echo "Rollback $file"
            else
                echo "No file found for number $1."
            fi
            ;;
        *)
            echo "Invalid argument. Usage: os-rollback [list|<number>]"
            ;;
        esac
      }

      list-applications() {
        OLD_IFS=$IFS
        IFS=':' read -rA dirs <<< "$XDG_DATA_DIRS"
        IFS=$OLD_IFS
        # 遍历每个路径
        for dir in "''${dirs[@]}"; do
            # 构建applications子目录的路径
            app_dir="$dir/applications"

            # 检查applications子目录是否存在
            if [ -d "$app_dir" ]; then
                echo "Listing applications folder in $dir:"
                # 列出applications子目录的内容
                ls -l "$app_dir"
            else
                echo "Applications folder not found in $dir"
            fi
        done
      }

      mime-type() {
        xdg-mime query filetype $@
      }
      mime-default() {
        xdg-mime query default $(mime_type $@)
      }

      no-proxy() {
        export all_proxy=
        export http_proxy=
        export https_proxy=
      }

      ${lib.optionalString os.config.virtualisation.waydroid.enable ''
      waydroid-settings() {
        waydroid prop set persist.waydroid.multi_windows false;
        waydroid prop set persist.waydroid.cursor_on_subsurface false;
        waydroid prop set persist.waydroid.height 0;
        waydroid prop set persist.waydroid.width 0;
      }
      waydroid-hide-desktops() {
        local dir="$HOME/.local/share/applications"

        if [ ! -d "$dir" ]; then
          echo "Directory $dir not found."
          return 1
        fi

        # 遍历指定目录下的以waydroid.开头的文件, 排除 waydroid.desktop
        for file in "$dir"/waydroid.*; do
          if [ -f "$file" ] && [ "$file" != "waydroid.desktop" ]; then
            grep -q 'NoDisplay=true' "$file" || sed -i '/^\[Desktop Entry\]$/a NoDisplay=true' "$file"
          fi
        done
      }
      ''}
    '';
    shellAliases = {
      ll = "ls -l";
      icat = "kitty +kitten icat";
      Tp = "trash put";
      Tl = "trash list";
    };
    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };
    zplug = {
      enable = true;
      plugins = [
        { name = "zsh-users/zsh-autosuggestions"; }
        { name = "zsh-users/zsh-completions"; }
        { name = "zsh-users/zsh-syntax-highlighting"; }
        { name = "romkatv/powerlevel10k"; tags = [ "as:theme" "depth:1" ]; } # Installations with additional options. For the list of options, please refer to Zplug README.
      ];
    };
  };
}
