{
  config,
  lib,
  ...
}: let
  toLua = lib.generators.toLua {};

  scripts = "${config.home.homeDirectory}/.config/hypr/scripts";
  bin = "${scripts}/bin";
in ''
  -- ============================================================
  -- Local variables
  -- ============================================================

  local bin = ${toLua bin}


  -- ============================================================
  -- Workspaces
  -- SUPER + 1..9,0
  -- SUPER + CTRL + 1..9,0
  -- ============================================================

  for n = 1, 10 do
    local key = n == 10 and "0" or tostring(n)
    local workspace = tostring(n)

    hl.bind(
      "SUPER + " .. key,
      hl.dsp.focus({
        workspace = workspace,
      })
    )

    hl.bind(
      "SUPER + CTRL + " .. key,
      hl.dsp.window.move({
        workspace = workspace,
        follow = true,
      })
    )
  end


  -- ============================================================
  -- Launcher
  -- ============================================================

  -- 原 bindr
  hl.bind(
    "SUPER + SUPER_L",
    hl.dsp.exec_cmd("mika-shell toggle mikami.app-launcher"),
    {
      release = true,
    }
  )

  -- 原 bindn
  hl.bind(
    "ALT + TAB",
    hl.dsp.exec_cmd("mika-shell open mikami.workspace -n -q keyboard=true"),
    {
      non_consuming = true,
    }
  )


  -- ============================================================
  -- Applications
  -- ============================================================

  -- VSCode
  hl.bind(
    "SUPER + C",
    hl.dsp.exec_cmd(bin .. "/launch-desktop.sh $EDITOR")
  )

  -- Browser
  hl.bind(
    "SUPER + B",
    hl.dsp.exec_cmd(bin .. "/launch-desktop.sh $BROWSER")
  )

  -- Terminal
  hl.bind(
    "SUPER + GRAVE",
    hl.dsp.exec_cmd("ghostty +new-window")
  )

  hl.bind(
    "SUPER + BACKSLASH",
    hl.dsp.exec_cmd("ghostty +new-window")
  )

  -- File manager
  hl.bind(
    "SUPER + E",
    hl.dsp.exec_cmd("nautilus")
  )


  -- ============================================================
  -- Window state
  -- ============================================================

  -- SUPER + Right Shift
  hl.bind(
    "SUPER + SHIFT_R",
    hl.dsp.window.float({
      action = "toggle",
    })
  )

  hl.bind(
    "SUPER + mouse:274",
    hl.dsp.window.float({
      action = "toggle",
    })
  )

  -- Pin
  hl.bind(
    "SUPER + P",
    hl.dsp.window.pin({
      action = "toggle",
    })
  )

  -- Close
  hl.bind(
    "SUPER + BackSpace",
    hl.dsp.window.close()
  )

  hl.bind(
    "SUPER + Q",
    hl.dsp.window.close()
  )


  -- ============================================================
  -- Utilities
  -- ============================================================

  -- Screenshot
  hl.bind(
    "SUPER + S",
    hl.dsp.exec_cmd("QT_SCALE_FACTOR=0.8 flameshot gui")
  )

  -- Screen recorder
  hl.bind(
    "SUPER + R",
    hl.dsp.exec_cmd("mika-shell toggle mikami.wf-recorder")
  )

  -- Clipboard
  hl.bind(
    "SUPER + V",
    hl.dsp.exec_cmd("mika-shell toggle mikami.clipboard")
  )

  -- Power menu
  hl.bind(
    "CONTROL + ALT + DELETE",
    hl.dsp.exec_cmd("mika-shell toggle mikami.power-menu")
  )

  -- Lockscreen
  hl.bind(
    "SUPER + L",
    hl.dsp.exec_cmd("mika-shell open mikami.lockscreen")
  )

  -- Quick run
  hl.bind(
    "ALT + SPACE",
    hl.dsp.exec_cmd("mika-shell toggle mikami.quick-run")
  )

  -- Side panel
  hl.bind(
    "SUPER + TAB",
    hl.dsp.exec_cmd("mika-shell toggle mikami.side-panel")
  )


  -- ============================================================
  -- Workspace navigation
  -- ============================================================

  hl.bind(
    "SHIFT + SUPER + left",
    hl.dsp.focus({
      workspace = "-1",
    })
  )

  hl.bind(
    "SHIFT + SUPER + right",
    hl.dsp.focus({
      workspace = "+1",
    })
  )

  hl.bind(
    "SHIFT + SUPER + H",
    hl.dsp.focus({
      workspace = "-1",
    })
  )

  hl.bind(
    "SHIFT + SUPER + L",
    hl.dsp.focus({
      workspace = "+1",
    })
  )


  -- ============================================================
  -- Focus window
  -- ============================================================

  hl.bind(
    "SUPER + left",
    hl.dsp.focus({
      direction = "l",
    })
  )

  hl.bind(
    "SUPER + right",
    hl.dsp.focus({
      direction = "r",
    })
  )

  hl.bind(
    "SUPER + up",
    hl.dsp.focus({
      direction = "u",
    })
  )

  hl.bind(
    "SUPER + down",
    hl.dsp.focus({
      direction = "d",
    })
  )

  hl.bind(
    "SUPER + H",
    hl.dsp.focus({
      direction = "l",
    })
  )

  hl.bind(
    "SUPER + L",
    hl.dsp.focus({
      direction = "r",
    })
  )

  hl.bind(
    "SUPER + K",
    hl.dsp.focus({
      direction = "u",
    })
  )

  hl.bind(
    "SUPER + J",
    hl.dsp.focus({
      direction = "d",
    })
  )


  -- ============================================================
  -- Move window
  -- ============================================================

  hl.bind(
    "SUPER + CONTROL + left",
    hl.dsp.window.move({
      direction = "l",
    })
  )

  hl.bind(
    "SUPER + CONTROL + right",
    hl.dsp.window.move({
      direction = "r",
    })
  )

  hl.bind(
    "SUPER + CONTROL + up",
    hl.dsp.window.move({
      direction = "u",
    })
  )

  hl.bind(
    "SUPER + CONTROL + down",
    hl.dsp.window.move({
      direction = "d",
    })
  )


  -- ============================================================
  -- Fullscreen
  -- ============================================================

  -- 原 fullscreen,1
  hl.bind(
    "SUPER + RETURN",
    hl.dsp.window.fullscreen({
      mode = "maximized",
      action = "toggle",
    })
  )

  -- 原 fullscreen
  hl.bind(
    "SUPER + SHIFT + RETURN",
    hl.dsp.window.fullscreen({
      mode = "fullscreen",
      action = "toggle",
    })
  )


  -- ============================================================
  -- Mouse wheel workspace
  -- ============================================================

  hl.bind(
    "SUPER + mouse_down",
    hl.dsp.focus({
      workspace = "e+1",
    })
  )

  hl.bind(
    "SUPER + mouse_up",
    hl.dsp.focus({
      workspace = "e-1",
    })
  )


  -- ============================================================
  -- Resize
  -- 原 binde
  -- ============================================================

  hl.bind(
    "SUPER + ALT + right",
    hl.dsp.window.resize({
      x = 60,
      y = 0,
      relative = true,
    }),
    {
      repeating = true,
    }
  )

  hl.bind(
    "SUPER + ALT + left",
    hl.dsp.window.resize({
      x = -60,
      y = 0,
      relative = true,
    }),
    {
      repeating = true,
    }
  )

  hl.bind(
    "SUPER + ALT + up",
    hl.dsp.window.resize({
      x = 0,
      y = -60,
      relative = true,
    }),
    {
      repeating = true,
    }
  )

  hl.bind(
    "SUPER + ALT + down",
    hl.dsp.window.resize({
      x = 0,
      y = 60,
      relative = true,
    }),
    {
      repeating = true,
    }
  )


  -- ============================================================
  -- Mouse
  -- 原 bindm
  -- ============================================================

  hl.bind(
    "SUPER + mouse:272",
    hl.dsp.window.drag(),
    {
      mouse = true,
    }
  )

  hl.bind(
    "SUPER + mouse:274",
    hl.dsp.window.drag(),
    {
      mouse = true,
    }
  )

  hl.bind(
    "SUPER + mouse:273",
    hl.dsp.window.resize(),
    {
      mouse = true,
    }
  )
''
