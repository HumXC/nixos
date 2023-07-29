{ config, lib, pkgs, profilename, ... }:{
  home.file.".p10k.zsh" = {
    source = ./.p10k.zsh;
  };
  home.packages = with pkgs; [
      fzf
  ];
  programs.zsh = {
    enable = true;
    enableCompletion = false;
    initExtraBeforeCompInit = ''
      # p10k instant prompt
      P10K_INSTANT_PROMPT="$XDG_CACHE_HOME/p10k-instant-prompt-''${(%):-%n}.zsh"
      [[ ! -r "$P10K_INSTANT_PROMPT" ]] || source "$P10K_INSTANT_PROMPT"
    '';
    initExtra = ''
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

      # 更新系统
      function os-update() {
        cd /etc/nixos
        now=$(date +"%Y-%m-%d-%H-%M-%S")
        cp flake.lock backup/flake.lock.$now.bak
        doas nix flake update
      }
    
      # 重新构建系统
      function os-build() {
        cd /etc/nixos
        doas nixos-rebuild switch --flake .#${profilename}
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
        { name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; } # Installations with additional options. For the list of options, please refer to Zplug README.
      ];
    };
  };
}