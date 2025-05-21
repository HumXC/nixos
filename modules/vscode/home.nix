{
  lib,
  config,
  pkgs,
  ...
}: {
  options.aris.vscode.enable = lib.mkEnableOption "vscode";
  config = lib.mkIf config.aris.vscode.enable {
    programs.vscode = {
      package = pkgs.unstable.vscode;
      enable = true;
      profiles.default.userSettings = import ./settings;
    };
  };
}
