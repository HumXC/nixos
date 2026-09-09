{config, ...}: let
  cfg = config.aris.hyprland;
in ''
  -- ============================================================
  -- Layer rules
  -- ============================================================

  hl.layer_rule({
    name = "popup-window",

    match = {
      namespace = "popup-window",
    },

    no_anim = true,
  })

  hl.layer_rule({
    name = "mikami-layer",

    match = {
      namespace = "mikami-layer",
    },

    no_anim = true,
  })

  ${
    if cfg.enableBlurAndOpacity
    then ''
      hl.layer_rule({
        name = "blur-opacity-all",

        match = {
          namespace = ".*",
        },

        blur = true,
        ignore_alpha = 0.5,
      })
    ''
    else ""
  }
''
