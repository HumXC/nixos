{
  # ========== 编辑器通用设置 ==========
  editor.suggestSelection = "first";
  editor.fontLigatures = true;
  editor.bracketPairColorization.enabled = true;
  editor.defaultFormatter = "esbenp.prettier-vscode";
  editor.formatOnSave = true;
  editor.maxTokenizationLineLength = 90000;
  editor.lineNumbers = "relative";
  editor.cursorSmoothCaretAnimation = "on";
  editor.accessibilitySupport = "off";
  editor.unicodeHighlight.invisibleCharacters = false;
  editor.minimap.renderCharacters = false;
  editor.minimap.showSlider = "always";
  editor.unicodeHighlight.ambiguousCharacters = false;
  editor.codeActionsOnSave = {
    source.fixAll = "never";
    source.organizeImports = "never";
  };
  editor.inlayHints.enabled = "offUnlessPressed";

  # ========== 工作区/文件管理 ==========
  workbench.editorAssociations = {
    "{hexdiff}:/**/*.*" = "hexEditor.hexedit";
    "*.ico" = "cweijan.officeViewer";
    "*.md" = "vscode.markdown.preview.editor";
    "*.png" = "imagePreview.previewEditor";
    "*.doc" = "default";
    "*.jpeg" = "cweijan.officeViewer";
    "{git,gitlens}:/**/*.{md,csv}" = "default";
    "*.svg" = "default";
    "{git,gitlens,git-graph}:/**/*.{md,csv,svg}" = "default";
  };
  workbench.panel.defaultLocation = "right";
  workbench.editor.showTabs = "single";
  workbench.tree.indent = 16;
  workbench.layoutControl.enabled = false;
  workbench.startupEditor = "none";
  workbench.list.smoothScrolling = true;
  workbench.iconTheme = "material-icon-theme";
  # ========== 终端设置 ==========
  terminal.external.linuxExec = "/bin/zsh";
  terminal.integrated.profiles.linux = {
    bash = {
      path = "bash";
      icon = "terminal-bash";
    };
    zsh = {path = "zsh";};
    fish = {path = "fish";};
  };
  terminal.integrated.defaultProfile.linux = "zsh";
  terminal.integrated.enableMultiLinePasteWarning = false;

  # ========== 调试相关 ==========
  debug.javascript.suggestPrettyPrinting = false;
  debug.console.acceptSuggestionOnEnter = "on";
  debug.openExplorerOnEnd = true;
  debug.showInStatusBar = "always";

  # ========== 安全设置 ==========
  security.workspace.trust.untrustedFiles = "open";

  # ========== 文件资源管理器 ==========
  explorer.confirmDelete = false;
  explorer.confirmDragAndDrop = false;
  explorer.confirmPasteNative = false;

  window.menuBarVisibility = "toggle";
  window.commandCenter = false;
  window.customTitleBarVisibility = "never";
  window.titleBarStyle = "native";

  # ========== 傻逼 Copilot ==========
  github.copilot.enable = {"*" = false;};
}
