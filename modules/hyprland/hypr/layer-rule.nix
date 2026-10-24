{config, ...}: let
  cfg = config.aris.hyprland;
in ''
  -- ============================================================
  -- Layer rules
  -- ============================================================

  hl.layer_rule({
    name = "mika-shell",

    match = {
      namespace = "mika-shell",
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
        blur_popups = true,
        ignore_alpha = 0.5,
      })
    ''
    else ""
  }
''
