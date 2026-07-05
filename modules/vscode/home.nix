{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.aris.vscode;
  vscodeFonts = config.stylix.fonts // {
    monospace = {
      package = pkgs.maple-mono.NF-CN-unhinted;
      name = "Maple Mono NF CN";
    };
  };
  stylixVscodeExtension = pkgs.runCommandLocal "stylix-vscode" {
    vscodeExtUniqueId = "stylix.stylix";
    vscodeExtPublisher = "stylix";
    version = "0.0.0";
    theme = builtins.toJSON (
      import "${inputs.stylix}/modules/vscode/templates/theme.nix" config.lib.stylix.colors
    );
    passAsFile = ["theme"];
  } ''
    mkdir -p "$out/share/vscode/extensions/$vscodeExtUniqueId/themes"
    ln -s ${inputs.stylix}/modules/vscode/package.json "$out/share/vscode/extensions/$vscodeExtUniqueId/package.json"
    cp "$themePath" "$out/share/vscode/extensions/$vscodeExtUniqueId/themes/stylix.json"
  '';
  stylixDefaultSettings =
    import "${inputs.stylix}/modules/vscode/templates/settings.nix" vscodeFonts;
  base = pkgs.unstable.vscode;
  wrappedVscode = pkgs.symlinkJoin {
    pname = base.pname;
    version = base.version;
    inherit (base) meta;
    paths = [base];
    buildInputs = [pkgs.makeWrapper];
    postBuild = ''
      rm -f $out/bin/code
      makeWrapper ${base}/bin/code $out/bin/code --set NIXOS_OZONE_WL "1"
    '';
  };
in {
  options.aris.vscode.enable = lib.mkEnableOption "vscode";
  config = lib.mkIf cfg.enable {
    stylix.targets.vscode.enable = false;
    programs.vscode = {
      enable = true;
      package = wrappedVscode;
      profiles.default = {
        extensions = [stylixVscodeExtension];
        userSettings = (import ./settings) // stylixDefaultSettings // {
          "editor.fontFamily" = "Maple Mono NF CN";
          "terminal.integrated.fontFamily" = "Maple Mono NF CN";
          "editor.inlayHints.fontFamily" = "Maple Mono NF CN";
          "editor.inlineSuggest.fontFamily" = "Maple Mono NF CN";
          "scm.inputFontFamily" = "Maple Mono NF CN";
          "debug.console.fontFamily" = "Maple Mono NF CN";
          "chat.editor.fontFamily" = "Maple Mono NF CN";
        };
      };
    };
  };
}