{config, ...}: let
  cfg = config.aris.hyprland;
in ''
  -- ============================================================
  -- Misc
  -- ============================================================

  hl.window_rule({
    name = "Global Opacity",

    match = {
      class = ".+",
    },

    opacity = "0.94 override 0.94 override",
  })

  hl.window_rule({
    name = "Brave Save File",

    match = {
      class = "brave",
      title = "保存文件",
    },

    size = { 950, 600 },
  })

  hl.window_rule({
    name = "MyProject",

    match = {
      class = "myproject",
    },

    float = true,
  })

  hl.window_rule({
    name = "KDE Polkit Agent",

    match = {
      class = "org.kde.polkit-kde-authentication-agent-1",
    },

    float = true,
  })

  hl.window_rule({
    name = "Gnome Polkit Agent",

    match = {
      class = "org.kde.polkit-gnome-authentication-agent-1",
    },

    dim_around = true,
  })

  hl.window_rule({
    name = "Network Manager Editor",

    match = {
      class = "nm-connection-editor",
    },

    float = true,
  })

  hl.window_rule({
    name = "Pavucontrol",

    match = {
      class = "pavucontrol",
    },

    float = true,
  })

  hl.window_rule({
    name = "Blueman Manager",

    match = {
      class = "blueman-manager",
    },

    float = true,
  })

  hl.window_rule({
    name = "Microsoft Edge",

    match = {
      class = "Microsoft-edge",
    },

    float = true,
    tile = true,
  })

  hl.window_rule({
    name = "VLC",

    match = {
      class = "vlc",
    },

    float = true,
  })

  hl.window_rule({
    name = "Ncmpcpp",

    match = {
      class = "ncmpcpp",
    },

    float = true,
  })

  hl.window_rule({
    name = "MPV",

    match = {
      class = "mpv",
    },

    float = true,
    center = true,
  })

  hl.window_rule({
    name = "Authenticate Title",

    match = {
      title = "Authenticate",
    },

    dim_around = true,
  })

  hl.window_rule({
    name = "Nautilus Inaccessible",

    match = {
      class = "org.gnome.Nautilus",
      title = "无法访问位置",
    },

    dim_around = true,
  })

  hl.window_rule({
    name = "GCR Prompter",

    match = {
      class = "gcr-prompter",
    },

    dim_around = true,
  })

  hl.window_rule({
    name = "GJS Clipboard",

    match = {
      class = "gjs",
      title = "clipboard",
    },

    float = true,
  })

  hl.window_rule({
    name = "Nextcloud Client",

    match = {
      class = "com.nextcloud.desktopclient.nextcloud",
    },

    float = true,
  })

  hl.window_rule({
    name = "KDE Ark",

    match = {
      class = "org.kde.ark",
    },

    float = true,
  })

  hl.window_rule({
    name = "XDG Desktop Portal",

    match = {
      class = "xdg-desktop-portal.+",
    },

    float = true,
  })

  hl.window_rule({
    name = "Zen Beta Opening",

    match = {
      class = "zen-beta",
      title = "^正在打开.+",
    },

    float = true,
  })

  hl.window_rule({
    name = "Yoshimi",

    match = {
      title = "^Yoshimi.+",
    },

    float = true,
  })

  hl.window_rule({
    name = "Zen PIP",

    match = {
      class = "zen",
      title = "画中画",
    },

    float = true,
  })

  hl.window_rule({
    name = "Ardour Input",

    match = {
      class = "Ardour",
    },

    allows_input = true,
  })


  -- ============================================================
  -- Steam
  -- ============================================================

  hl.window_rule({
    name = "Steam",

    match = {
      class = "steam",
    },

    float = true,
  })


  -- ============================================================
  -- QQ
  -- ============================================================

  hl.window_rule({
    name = "QQ Viewer",

    match = {
      class = "(QQ)",
      title = "^(图片查看器|视频播放器|.+的聊天记录)$",
    },

    float = true,
    center = true,
  })


  -- ============================================================
  -- Wine
  -- ============================================================

  hl.window_rule({
    name = "Wine Explorer",

    match = {
      class = "explorer.exe",
    },

    tile = true,
  })

  hl.window_rule({
    name = "FL Studio 64",

    match = {
      class = "fl64.exe",
    },

    fullscreen = true,
    tile = true,
  })

  hl.window_rule({
    name = "Wine Settings",

    match = {
      title = "Wine 设置",
    },

    size = { 800, 800 },
  })


  -- ============================================================
  -- Pot
  -- ============================================================

  hl.window_rule({
    name = "Pot",

    match = {
      class = "Pot",
    },

    float = true,
    pin = true,
  })


  -- ============================================================
  -- UPBGE
  -- ============================================================

  hl.window_rule({
    name = "Blender UPBGE",

    match = {
      class = "Blender",
      title = "[UPBGE]",
    },

    float = true,
  })


  -- ============================================================
  -- WPS Office
  -- ============================================================

  hl.window_rule({
    name = "WPS Office",

    match = {
      class = "^(wps)|(et)|(wpp)|(pdf)$",
    },

    tile = true,
  })

  hl.window_rule({
    name = "WPS Office Title",

    match = {
      title = "^(wps)|(et)|(wpp)|(pdf)$",
    },

    float = true,
  })


  -- ============================================================
  -- VSCode
  -- ============================================================

  hl.window_rule({
    name = "VSCode Dialogs",

    match = {
      class = "Code",
      title = "^(打开文件夹)|(打开文件)$",
    },

    center = true,
    dim_around = true,
  })


  -- ============================================================
  -- Telegram
  -- ============================================================

  hl.window_rule({
    name = "Telegram Media Viewer",

    match = {
      class = "org.telegram.desktop",
      title = "^(.*)(媒体查看器)$",
    },

    float = true,
    fullscreen = true,
    opacity = "1.0 override 1.0 override",
  })

  hl.window_rule({
    name = "Telegram Media Viewer EN",

    match = {
      class = "org.telegram.desktop",
      title = "^(.*)(Media viewer)$",
    },

    float = true,
    fullscreen = true,
    opacity = "1.0 override 1.0 override",
  })


  -- ============================================================
  -- KDE Connect
  -- ============================================================

  hl.window_rule({
    name = "KDE Connect Handler",

    match = {
      class = "org.kde.kdeconnect.handler",
    },

    float = true,
  })


  -- ============================================================
  -- Waydroid
  -- ============================================================

  hl.window_rule({
    name = "Waydroid",

    match = {
      class = " Waydroid",
      title = "Waydroid",
    },

    fullscreen = true,
  })


  -- ============================================================
  -- Godot
  -- ============================================================

  hl.window_rule({
    name = "Godot Confirm",

    match = {
      class = "Godot",
      title = "请确认...",
    },

    dim_around = true,
  })


  -- ============================================================
  -- REAPER
  -- ============================================================

  hl.window_rule({
    name = "Reaper Tile",

    match = {
      title = "REAPER v.*",
    },

    tile = true,
  })

  hl.window_rule({
    name = "Reaper Routing",

    match = {
      class = "REAPER",
      title = "^轨道路由.*",
    },

    dim_around = true,
  })

  hl.window_rule({
    name = "Reaper Plugin Pins",

    match = {
      class = "REAPER",
      title = "^.*插件引脚连接器.$",
    },

    dim_around = true,
  })


  hl.window_rule({
    match = { class = "^(Pixelorama|blender|Godot)$" },
    opacity = "1.0 override"
  })



  -- ============================================================
  -- Opacity fallback
  -- ============================================================

  ${
    if !cfg.enableBlurAndOpacity
    then ''
      hl.window_rule({
        name = "Force Opacity 1",

        match = {
          class = ".+",
        },

        opacity = "1 override 1 override",
      })
    ''
    else ""
  }
''
