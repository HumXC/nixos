{
  lib,
  config,
  pkgs,
  ...
}: {
  options.aris.vscode.enable = lib.mkEnableOption "vscode";
  config = lib.mkIf config.aris.vscode.enable {
    programs.vscode = let
      base = pkgs.unstable.vscode;
      wrappedVscode = pkgs.symlinkJoin {
        pname = base.pname;
        version = base.version;
        inherit (base) meta;
        paths = [base];
        buildInputs = [pkgs.makeWrapper];
        postBuild = ''
          rm -f $out/bin/code
          rm -f $out/bin/.code-wrapped
          makeWrapper ${base}/bin/code $out/bin/code --set NIXOS_OZONE_WL "1"
        '';
      };
    in {
      package = wrappedVscode;
      enable = true;
      profiles.default.userSettings = import ./settings;
    };
  };
}
