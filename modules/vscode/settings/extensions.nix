{
  # ========== 版本控制 (Git) ==========
  git.confirmSync = false;
  git.autofetch = true;
  git.suggestSmartCommit = false;
  git.openRepositoryInParentFolders = "never";
  git.ignoreRebaseWarning = true;

  # ========== 扩展特定设置 ==========
  vsintellicode.modify.editor.suggestSelection = "automaticallyOverrodeDefaultValue";
  vsintellicode.features.apiExamplests = "enabled";
  vsintellicode.features.python.deepLearning = "enabled";
  vsintellicode.features.apiExamples = "enabled";
  settingsSync.ignoredExtensions = ["platformio.platformio-ide"];
  tabnine.experimentalAutoImports = true;
  vscode-office.openOutline = false;
  fittencode.disableSpecificInlineCompletion.suffixes = "";
  fittencode.inlineCompletion.enable = true;

  # ========== 格式化和Lint工具 ==========
  json.format.enable = false;
  prettier.printWidth = 100;
  prettier.tabWidth = 4;

  # ========== 语言工具配置 ==========
  go.toolsManagement.autoUpdate = true;
  go.autocompleteUnimportedPackages = true;
  C_Cpp.autocompleteAddParentheses = true;
  zig.zls.enabled = "on";
  zig.path = "zig";
  zig.zls.path = "zls";
  nix.serverPath = "nixd";
  nix.serverSettings = {nixd.formatting.command = ["alejandra"];};
  nix.formatterPath = "alejandra";
  nix.enableLanguageServer = true;
  vala.languageServerPath = "vala-language-server";
  mesonbuild.downloadLanguageServer = false;

  # ========== 杂项设置 ==========
  cmake.configureOnOpen = true;
  typescript.updateImportsOnFileMove.enabled = "always";
  javascript.updateImportsOnFileMove.enabled = "always";
  liveServer.settings.donotShowInfoMsg = true;
  files.associations = {dunstrc = "toml";};
  diffEditor.ignoreTrimWhitespace = false;
  diffEditor.maxComputationTime = 0;
  update.mode = "none";
  update.showReleaseNotes = false;
  svg.preview.mode = "svg";
  fittencode.languagePreference.displayPreference = "zh-cn";
  fittencode.languagePreference.commentPreference = "zh-cn";
  lldb.suppressUpdateNotifications = true;
  cmake.pinnedCommands = [
    "workbench.action.tasks.configureTaskRunner"
    "workbench.action.tasks.runTask"
  ];
  cmake.showConfigureWithDebuggerNotification = false;
  cmake.options.statusBarVisibility = "visible";
  cmake.showOptionsMovedNotification = false;
  python.createEnvironment.trigger = "off";
  githubPullRequests.pullBranch = "never";
}
