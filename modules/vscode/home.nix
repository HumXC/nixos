{
  lib,
  config,
  ...
}: {
  options.aris.vscode.enable = lib.mkEnableOption "vscode";
  config = lib.mkIf config.aris.vscode.enable {
    programs.vscode = {
      enable = true;
      userSettings = import ./settings;
    };
  };
}
