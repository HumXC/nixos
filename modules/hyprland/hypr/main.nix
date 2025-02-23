{config, ...}: let
  cfg = config.aris.hyprland;
in {
  xwayland = {
    force_zero_scaling = true;
  };

  input = {
    follow_mouse = 1;
    float_switch_override_focus = 2;
    touchpad = {
      natural_scroll = "yes";
    };
    sensitivity = 0.04; # -1.0 - 1.0, 0 means no modification.
  };
  general = {
    gaps_in = 4;
    gaps_out = 8;
    border_size = 2;
    # "col.inactive_border" = "0xf24b4b4b";
    # "col.active_border" = "0xffdddddd";
  };
  decoration = {
    rounding = 6;
    blur = {
      enabled = cfg.enableBlurAndOpacity;
      popups = true;
      passes = 2;
      size = 12;
      noise = 0.06;
    };
  };

  layerrule = [
    "blur, .+"
    "ignorealpha 0, .+"
    "noanim, popup-window"
  ];
  bezier = [
    "bz1,0.87, 0, 0.13, 1"
    "bz2,0.04, 0.48, 0.1, 0.79"
    "bz3,0.82,0.28,0.47,0.64"
  ];
  animations = {
    enabled = true;
    layers = {
      animation = [
        "layersIn,1,1,bz1"
        "layersOut,1,1,bz1"
      ];
    };
    windows = {
      animation = [
        "windowsIn,1,2,default"
        "windowsOut,1,2,bz1"
        "windowsMove,1,2,default"
      ];
    };
    fade = {
      animation = [
        "fadeIn,1,2,default"
        "fadeOut,1,2,bz2"
        "fadeSwitch,1,2,default"
        "fadeShadow,1,1,default"
        "fadeDim,1,2,bz3"
        "fadeLayersIn,1,1,bz2"
        "fadeLayersOut,1,1,bz2"
      ];
    };
    animation = [
      "border,1,6,bz2"
      "borderangle,1,1,bz3,loop"
      "workspaces,1,4,bz1"
    ];
  };

  dwindle = {
    pseudotile = 0; # enable pseudotiling on dwindle
  };

  misc = {
    disable_hyprland_logo = "yes";
    animate_mouse_windowdragging = true;
    vfr = false;
    middle_click_paste = false;
  };

  gestures = {
    workspace_swipe = "yes";
    workspace_swipe_fingers = 3;
  };
}
