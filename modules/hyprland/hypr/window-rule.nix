{
  lib,
  config,
  ...
}: let
  cfg = config.aris.hyprland;
in {
  windowrule =
    [
      # 杂项
      {
        name = "Global Opacity";
        "match:class" = ".+";
        opacity = "0.94 override 0.94 override";
      }
      {
        name = "Brave Save File";
        "match:class" = "brave";
        "match:title" = "保存文件";
        size = "950 600";
      }
      {
        name = "MyProject";
        "match:class" = "myproject";
        float = true;
      }
      {
        name = "KDE Polkit Agent";
        "match:class" = "org.kde.polkit-kde-authentication-agent-1";
        float = true;
      }
      {
        name = "Gnome Polkit Agent";
        "match:class" = "org.kde.polkit-gnome-authentication-agent-1";
        dim_around = true;
      }
      {
        name = "Network Manager Editor";
        "match:class" = "nm-connection-editor";
        float = true;
      }
      {
        name = "Pavucontrol";
        "match:class" = "pavucontrol";
        float = true;
      }
      {
        name = "Blueman Manager";
        "match:class" = "blueman-manager";
        float = true;
      }
      {
        name = "Microsoft Edge";
        "match:class" = "Microsoft-edge";
        float = true;
        tile = true;
      }
      {
        name = "VLC";
        "match:class" = "vlc";
        float = true;
      }
      {
        name = "Ncmpcpp";
        "match:class" = "ncmpcpp";
        float = true;
      }
      {
        name = "MPV";
        "match:class" = "mpv";
        float = true;
        center = true;
      }
      {
        name = "Authenticate Title";
        "match:title" = "Authenticate";
        dim_around = true;
      }
      {
        name = "Nautilus Inaccessible";
        "match:class" = "org.gnome.Nautilus";
        "match:title" = "无法访问位置";
        dim_around = true;
      }
      {
        name = "GCR Prompter";
        "match:class" = "gcr-prompter";
        dim_around = true;
      }
      {
        name = "GJS Clipboard";
        "match:class" = "gjs";
        "match:title" = "clipboard";
        float = true;
      }
      {
        name = "Nextcloud Client";
        "match:class" = "com.nextcloud.desktopclient.nextcloud";
        float = true;
      }
      {
        name = "KDE Ark";
        "match:class" = "org.kde.ark";
        float = true;
      }
      {
        name = "XDG Desktop Portal";
        "match:class" = "xdg-desktop-portal.+";
        float = true;
      }
      {
        name = "Zen Beta Opening";
        "match:class" = "zen-beta";
        "match:title" = "^正在打开.+";
        float = true;
      }
      {
        name = "Yoshimi";
        "match:title" = "^Yoshimi.+";
        float = true;
      }
      {
        name = "Zen PIP";
        "match:class" = "zen";
        "match:title" = "画中画";
        float = true;
      }
      {
        name = "Ardour Input";
        "match:class" = "Ardour";
        allows_input = true;
      }

      # steam
      {
        name = "Steam";
        "match:class" = "steam";
        float = true;
      }

      # qq
      {
        name = "QQ Viewer";
        "match:class" = "(QQ)";
        "match:title" = "^(图片查看器|视频播放器|.+的聊天记录)$";
        float = true;
        center = true;
      }

      # Wine
      {
        name = "Wine Explorer";
        "match:class" = "explorer.exe";
        tile = true;
      }
      {
        name = "FL Studio 64";
        "match:class" = "fl64.exe";
        fullscreen = true;
        tile = true;
      }
      {
        name = "Wine Settings";
        "match:title" = "Wine 设置";
        size = "800 800";
      }

      # pot
      {
        name = "Pot";
        "match:class" = "Pot";
        float = true;
        pin = true;
      }

      # UPBGE
      {
        name = "Blender UPBGE";
        "match:class" = "Blender";
        "match:title" = "[UPBGE]";
        float = true;
      }

      # WPS-Office
      {
        name = "WPS Office";
        "match:class" = "^(wps)|(et)|(wpp)|(pdf)$";
        tile = true;
      }
      {
        name = "WPS Office Title";
        "match:title" = "^(wps)|(et)|(wpp)|(pdf)$";
        float = true;
      }

      # vscode
      {
        name = "VSCode Dialogs";
        "match:class" = "Code";
        "match:title" = "^(打开文件夹)|(打开文件)$";
        center = true;
        dim_around = true;
      }

      # Telegram
      {
        name = "Telegram Media Viewer";
        "match:class" = "org.telegram.desktop";
        "match:title" = "^(.*)(媒体查看器)$";
        float = true;
        fullscreen = true;
        opacity = "1.0 override 1.0 override";
      }
      {
        name = "Telegram Media Viewer EN";
        "match:class" = "org.telegram.desktop";
        "match:title" = "^(.*)(Media viewer)$";
        float = true;
        fullscreen = true;
        opacity = "1.0 override 1.0 override";
      }

      # kdeconnect
      {
        name = "KDE Connect Handler";
        "match:class" = "org.kde.kdeconnect.handler";
        float = true;
      }

      # waydroid
      {
        name = "Waydroid";
        "match:class" = " Waydroid";
        "match:title" = "Waydroid";
        fullscreen = true;
      }

      # godot
      {
        name = "Godot Confirm";
        "match:class" = "Godot";
        "match:title" = "请确认...";
        dim_around = true;
      }

      # reaper
      {
        name = "Reaper Tile";
        "match:title" = "REAPER v.*";
        tile = true;
      }
      {
        name = "Reaper Routing";
        "match:class" = "REAPER";
        "match:title" = "^轨道路由.*";
        dim_around = true;
      }
      {
        name = "Reaper Plugin Pins";
        "match:class" = "REAPER";
        "match:title" = "^.*插件引脚连接器.$";
        dim_around = true;
      }
    ]
    ++ (
      if (!cfg.enableBlurAndOpacity)
      then [
        {
          name = "Force Opacity 1";
          "match:class" = ".+";
          opacity = "1 override 1 override";
        }
      ]
      else []
    );
}
