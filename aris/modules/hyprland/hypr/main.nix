{ ... }: {
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
    "col.inactive_border" = "0xf24b4b4b";
    "col.active_border" = "0xffdddddd";
    apply_sens_to_raw = 1; # whether to apply the sensitivity to raw input (e.g. used by games where you aim using your mouse)
    #damage_tracking=full # leave it on full unless you hate your GPU and want to make it suffer
  };
  decoration = {
    drop_shadow = true;
    # 圆角
    rounding = 6;
    blur = {
      passes = 2;
      noise = 0.06;
      size = 12;
      # xray = true;
    };
  };


  layerrule = [
    "blur, rofi"
    "ignorezero, rofi"
    "blur, top-bar.*"
    "ignorealpha 0.5, top-bar.*"

    "blur, right-bar.*"
    "ignorealpha 0.5, right-bar.*"

    "blur, notifications"
    "ignorealpha 0.5, notifications"


    "animation slide right, swaync-control-center"
    "animation slide right, swaync-notification-window"
    "blur, swaync-control-center"
    "blur, swaync-notification-window"
    "ignorezero, swaync-control-center"
    "ignorezero, swaync-notification-window"
    "ignorealpha 0.5, swaync-control-center"
    "ignorealpha 0.5, swaync-notification-window"
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
    no_gaps_when_only = 0;
  };

  misc = {
    disable_hyprland_logo = "yes";
    animate_mouse_windowdragging = true;
    vfr = false;
  };

  gestures = {
    workspace_swipe = "yes";
    workspace_swipe_fingers = 3;
  };

}
