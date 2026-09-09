{
  config,
  lib,
  ...
}: let
  cfg = config.aris.hyprland;

  toLua = lib.generators.toLua {};
in ''
  -- ============================================================
  -- General configuration
  -- ============================================================

  hl.config({
    xwayland = {
      force_zero_scaling = true,
    },

    input = {
      follow_mouse = 1,
      float_switch_override_focus = 2,

      touchpad = {
        natural_scroll = true,
      },

      -- -1.0 ~ 1.0, 0 means no modification.
      sensitivity = -1,
    },

    general = {
      gaps_in = 4,
      gaps_out = 8,
      border_size = 2,
    },

    decoration = {
      rounding = 6,

      blur = {
        enabled = ${toLua cfg.enableBlurAndOpacity},
        popups = true,
        passes = 2,
        size = 12,
        noise = 0.06,
      },
    },

    animations = {
      enabled = true,
    },

    misc = {
      disable_hyprland_logo = true,
      animate_mouse_windowdragging = true,
      middle_click_paste = false,
      focus_on_activate = true,
    },
  })


  -- ============================================================
  -- Curves
  -- ============================================================

  hl.curve("bz1", {
    type = "bezier",
    points = {
      { 0.87, 0 },
      { 0.13, 1 },
    },
  })

  hl.curve("bz2", {
    type = "bezier",
    points = {
      { 0.04, 0.48 },
      { 0.1, 0.79 },
    },
  })

  hl.curve("bz3", {
    type = "bezier",
    points = {
      { 0.82, 0.28 },
      { 0.47, 0.64 },
    },
  })


  -- ============================================================
  -- Layer animations
  -- ============================================================

  hl.animation({
    leaf = "layersIn",
    enabled = true,
    speed = 1,
    bezier = "bz1",
  })

  hl.animation({
    leaf = "layersOut",
    enabled = true,
    speed = 1,
    bezier = "bz1",
  })


  -- ============================================================
  -- Window animations
  -- ============================================================

  hl.animation({
    leaf = "windowsIn",
    enabled = true,
    speed = 2,
    bezier = "default",
  })

  hl.animation({
    leaf = "windowsOut",
    enabled = true,
    speed = 2,
    bezier = "bz1",
  })

  hl.animation({
    leaf = "windowsMove",
    enabled = true,
    speed = 2,
    bezier = "default",
  })


  -- ============================================================
  -- Fade animations
  -- ============================================================

  hl.animation({
    leaf = "fadeIn",
    enabled = true,
    speed = 2,
    bezier = "default",
  })

  hl.animation({
    leaf = "fadeOut",
    enabled = true,
    speed = 2,
    bezier = "bz2",
  })

  hl.animation({
    leaf = "fadeSwitch",
    enabled = true,
    speed = 2,
    bezier = "default",
  })

  hl.animation({
    leaf = "fadeShadow",
    enabled = true,
    speed = 1,
    bezier = "default",
  })

  hl.animation({
    leaf = "fadeDim",
    enabled = true,
    speed = 2,
    bezier = "bz3",
  })

  hl.animation({
    leaf = "fadeLayersIn",
    enabled = true,
    speed = 1,
    bezier = "bz2",
  })

  hl.animation({
    leaf = "fadeLayersOut",
    enabled = true,
    speed = 1,
    bezier = "bz2",
  })


  -- ============================================================
  -- Other animations
  -- ============================================================

  hl.animation({
    leaf = "border",
    enabled = true,
    speed = 6,
    bezier = "bz2",
  })

  hl.animation({
    leaf = "borderangle",
    enabled = true,
    speed = 1,
    bezier = "bz3",
    style = "loop",
  })

  hl.animation({
    leaf = "workspaces",
    enabled = true,
    speed = 4,
    bezier = "bz1",
  })
''
