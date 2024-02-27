{ config, ... }@all:
let
  loadModuleWithCfg = modulePath:
    let
      name = baseNameOf modulePath;
      cfg = config.os.programs.${name};
    in
    import modulePath ({ inherit cfg; } // all);
in
{
  imports = [
    (loadModuleWithCfg ./fcitx5)
    (loadModuleWithCfg ./helix)
    (loadModuleWithCfg ./hyprland)
    (loadModuleWithCfg ./kitty)
    (loadModuleWithCfg ./rofi)
    (loadModuleWithCfg ./waybar)
    (loadModuleWithCfg ./zsh)
  ];
}
