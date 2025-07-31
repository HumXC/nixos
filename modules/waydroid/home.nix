{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.aris.fish;
in {
  options.aris.waydroid.enable = lib.mkEnableOption "waydroid";
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [];

    programs.fish = {
      functions = {
        waydroid-settings = ''
          waydroid prop set persist.waydroid.multi_windows false
          waydroid prop set persist.waydroid.cursor_on_subsurface false
          waydroid prop set persist.waydroid.height 0
          waydroid prop set persist.waydroid.width 0
        '';
        waydroid-hide-desktops = ''
          set dir "$HOME/.local/share/applications"
          if not test -d "$dir"
              echo "Directory $dir not found."
              return 1
          end
          # 遍历指定目录下的以 waydroid. 开头的文件, 排除 waydroid.desktop
          for file in $dir/waydroid.*
              if test -f "$file" && test "$file" != "$dir/waydroid.desktop"
                  if not grep -q 'NoDisplay=true' "$file"
                      sed -i '/^\[Desktop Entry\]$/a NoDisplay=true' "$file"
                  end
              end
          end
        '';
      };
    };
  };
}
