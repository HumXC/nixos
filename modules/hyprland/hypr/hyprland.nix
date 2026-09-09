{
  config,
  lib,
  pkgs,
  ...
}: let
  desktop = config.aris.desktop;

  toLua = lib.generators.toLua {};

  scripts = "${config.home.homeDirectory}/.config/hypr/scripts";
  bin = "${scripts}/bin";

  # ------------------------------------------------------------
  # Monitor
  # ------------------------------------------------------------

  monitorsLua =
    lib.concatMapStringsSep "\n\n"
    (m: ''
      hl.monitor({
        output = ${toLua m.name},
        mode = ${toLua "${toString m.size}@${toString m.rate}"},
        position = "auto",
        scale = ${toString m.scale},
      })
    '')
    desktop.monitor;

  # ------------------------------------------------------------
  # Autostart
  # ------------------------------------------------------------

  startupCommands =
    desktop.execOnce
    ++ [
      # 解决部分 XWayland 窗口中鼠标指针显示为 X
      "${pkgs.xsetroot}/bin/xsetroot -cursor_name left_ptr"

      "${builtins.replaceStrings ["\n"] [";"] config.xsession.profileExtra}"

      # Clipboard
      "${pkgs.wl-clipboard}/bin/wl-paste --type text --watch cliphist store"
      "${pkgs.wl-clipboard}/bin/wl-paste --type image --watch cliphist store"
      "${pkgs.wl-clipboard}/bin/wl-clip-persist --clipboard both"

      "hyprctl setcursor ${config.stylix.cursor.name} ${toString config.stylix.cursor.size}"
    ];

  startupLua =
    lib.concatMapStringsSep "\n"
    (command: "  hl.exec_cmd(${toLua command})")
    startupCommands;

  # ------------------------------------------------------------
  # NVIDIA
  # ------------------------------------------------------------

  nvidiaEnvLua = lib.optionalString desktop.useNvidia ''
    hl.env("LIBVA_DRIVER_NAME", "nvidia")
    hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
    hl.env("NVD_BACKEND", "direct")
  '';

  noHardwareCursors =
    if desktop.useNvidia
    then 1
    else 0;
in ''
  -- ============================================================
  -- Local variables
  -- ============================================================

  local scripts = ${toLua scripts}
  local bin = ${toLua bin}


  -- ============================================================
  -- Environment
  -- ============================================================

  hl.env("GLFW_IM_MODULE", "ibus")

  hl.env("MOZ_ENABLE_WAYLAND", "1")
  hl.env("SDL_VIDEODRIVER", "wayland")
  hl.env("_JAVA_AWT_WM_NONREPARENTING", "1")

  hl.env("QT_QPA_PLATFORM", "wayland")
  hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")

  hl.env("CLUTTER_BACKEND", "wayland")

  hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
  hl.env("XDG_SESSION_DESKTOP", "Hyprland")
  hl.env("XDG_SESSION_TYPE", "wayland")

  hl.env("HYPRCURSOR_THEME", ${toLua config.stylix.cursor.name})
  hl.env("HYPRCURSOR_SIZE", ${toLua (toString config.stylix.cursor.size)})

  ${nvidiaEnvLua}


  -- ============================================================
  -- Cursor
  -- ============================================================

  hl.config({
    cursor = {
      no_hardware_cursors = ${toString noHardwareCursors},
    },
  })


  -- ============================================================
  -- Monitors
  -- ============================================================

  ${monitorsLua}


  -- ============================================================
  -- Autostart
  -- ============================================================

  hl.on("hyprland.start", function()
  ${startupLua}
  end)
''
