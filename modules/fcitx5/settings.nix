{
  addons.notifications.sections.HiddenNotifications = {
    "0" = "enumerate-group";
    "1" = "wayland-diagnose-other";
  };
  addons.classicui.globalSection.PreferTextIcon = "True";
  addons.keyboard.globalSection = {
    PageSize = 10;
    EnableEmoji = "True";
    UseNewComposeBehavior = "True";
  };
  addons.pinyin.globalSection = {
    PageSize = 7;
    SpellEnabled = "True";
    SymbolsEnabled = "True";
    ChaiziEnabled = "True";
    ExtBEnabled = "True";
    CloudPinyinEnabled = "True";
    CloudPinyinIndex = 2;
    CloudPinyinAnimation = "True";
    PinyinInPreedit = "True";
    Prediction = "False";
    SwitchInputMethodBehavior = "Commit current preedit";
    SecondCandidate = "";
    ThirdCandidate = "";
    UseKeypadAsSelection = "True";
    BackSpaceToUnselect = "True";
    NumberOfSentence = 2;
    LongWordLengthLimit = 4;
    QuickPhraseKey = "";
    VAsQuickphrase = "False";
    FirstRun = "False";
  };

  addons.pinyin.sections.PrevPage = {
    "0" = "minus";
    "1" = "Up";
    "2" = "KP_Up";
    "3" = "bracketleft";
  };
  addons.pinyin.sections.NextPage = {
    "0" = "equal";
    "1" = "Down";
    "2" = "KP_Down";
    "3" = "bracketright";
  };
  addons.pinyin.sections.PrevCandidate = {
    "0" = "Shift+Tab";
  };
  addons.pinyin.sections.NextCandidate = {
    "0" = "Tab";
  };
  addons.pinyin.sections.CurrentCandidate = {
    "0" = "space";
    "1" = "KP_Space";
  };
  addons.pinyin.sections.CommitRawInput = {
    "0" = "Return";
    "1" = "KP_Enter";
    "2" = "Control+Return";
    "3" = "Control+KP_Enter";
    "4" = "Shift+Return";
    "5" = "Shift+KP_Enter";
    "6" = "Control+Shift+Return";
    "7" = "Control+Shift+KP_Enter";
    "8" = "-";
    "9" = "(";
    "10" = ")";
    "11" = "/";
    "12" = "*";
    "13" = ".";
    "14" = ",";
    "15" = ";";
    "16" = ":";
    "17" = "?";
    "18" = "!";
    "19" = "|";
    "23" = "}";
    "24" = "{";
    "25" = ">";
    "26" = "<";
    "27" = "\"";
  };
  addons.cloudpinyin.globalSection = {
    MinimumPinyinLength = 2;
    Backend = "Baidu";
    "Toggle Key" = "";
  };
  addons.quickphrase.globalSection.TriggerKey = "";
  addons.clipboard.globalSection.TriggerKey = "";
  globalOptions = {
    Hotkey = {
      EnumerateWithTriggerKeys = true;
      EnumerateSkipFirst = true;
    };
    "Hotkey/EnumerateBackwardKeys" = {
      "0" = "Shift+Shift_L";
    };
    "Hotkey/EnumerateGroupForwardKeys" = {
      "0" = "Super+space";
    };
    "Hotkey/PrevCandidate" = {
      "0" = "Super+Tab";
    };
    "Hotkey/NextCandidate" = {
      "0" = "Tab";
    };
    Behavior = {
      ActiveByDefault = false;
      ResetStateWhenFocusIn = false;
      ShareInputState = false;
      PreeditEnabledByDefault = true;
      ShowInputMethodInformation = true;
      ShowInputMethodInformationWhenFocusIn = false;
      CompactInputMethodInformation = true;
      ShowFirstInputMethodInformation = true;
      DefaultPageSize = 5;
      OverrideXkbOption = false;
      PreloadInputMethod = true;
      AllowInputMethodForPassword = false;
      ShowPreeditForPassword = false;
    };
  };
  inputMethod = {
    "Groups/0" = {
      "Name" = "EN";
      "Default Layout" = "us";
      "DefaultIM" = "keyboard-us";
    };
    "Groups/0/Items/0" = {
      "Name" = "keyboard-us";
      "Layout" = "";
    };
    "Groups/1" = {
      "Name" = "CN";
      "Default Layout" = "us";
      "DefaultIM" = "keyboard-us";
    };
    "Groups/1/Items/0" = {
      "Name" = "pinyin";
      "Layout" = "";
    };
    "Groups/1/Items/1" = {
      "Name" = "keyboard-us";
      "Layout" = "";
    };
    "GroupOrder" = {
      "0" = "CN";
      "1" = "EN";
    };
  };
}
