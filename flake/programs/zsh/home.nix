{ config, lib, pkgs, os, ... }:
let
  profileName = os.profileName;
  scale = toString os.desktop.scaleFactor;
in
{
  home.file.".p10k.zsh" = {
    source = ./.p10k.zsh;
  };
  home.packages = with pkgs; [
    fzf
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
        function rm() {cowsay -f sodomized "Fuck rm! Use Tp (trash put)"}

        # 编辑系统
        function os-edit() {
          code /etc/nixos
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
          pwd=$(pwd)
          cd /etc/nixos
          doas nixos-rebuild switch --flake .#${profileName}
          cd "$pwd"
        }
        # 尝试评估构建系统
        function os-try-build() {
          local flake_identifier=''${1:-${profileName}}  
          local pwd=$(pwd)
          cd /etc/nixos
          doas nixos-rebuild dry-build --flake .#$flake_identifier
          cd "$pwd"
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
