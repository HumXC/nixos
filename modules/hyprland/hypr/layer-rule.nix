{
  lib,
  config,
  ...
}: let
  cfg = config.aris.hyprland;
in {
  layerrule =
    [
      {
        name = "popup-window";
        "match:namespace" = "popup-window";
        no_anim = "on";
      }
      {
        name = "mikami-layer";
        "match:namespace" = "mikami-layer";
        no_anim = "on";
      }
    ]
    ++ (
      if cfg.enableBlurAndOpacity
      then [
        {
          name = "blur-opacity-all";
          "match:namespace" = ".*";
          blur = "on";
          ignore_alpha = "0.5";
        }
      ]
      else [
      ]
    );
}
