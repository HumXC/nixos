{ config, lib, pkgs, ... }:{
  home.file.".p10k.zsh" = {
    source = ./.p10k.zsh;
  };
  home.packages = with pkgs; [
      fzf
  ];
  programs.zsh = {
    enable = true;
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
    '';
    shellAliases = {
      ll = "ls -l";
      icat = "kitty +kitten icat";
      os-update = ''cd /etc/nixos;now=$(date +"%Y-%m-%d-%H-%M-%S");cp flake.lock backup/flake.lock.$now.bak;doas nix flake update'';
      os-build = "cd /etc/nixos;doas nixos-rebuild switch --flake .#laptop";
      Tp = "trash put";
      Tl = "trash list";
      rm = "cowsay 不要使用 rm 使用 Tp";
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