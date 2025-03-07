{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.aris.daw;
  hideDesktopEntry = package: entryNames: let
    names = builtins.toString (map (e: "\"" + e + "\"") entryNames);
  in
    with pkgs;
      lib.hiPrio
      (runCommand "$patched-desktop-entry-for-${package.name}" {} ''
        ${coreutils}/bin/mkdir -p $out/share/applications
        if [ -z "${names}" ]; then
          # 如果 names 为空，则隐藏所有的 .desktop 文件
          for file in ${package}/share/applications/*.desktop; do
            ${gawk}/bin/awk '/^\[/{if(flag){print "NoDisplay=true"} flag=0} /^\[Desktop Entry\]$/ { flag=1 } { print } END {if(flag) print "NoDisplay=true"}' \
            $file > $out/share/applications/$(basename $file)
          done
        else
          # 否则仅处理指定的 names 列表中的文件
          for name in ${names}; do
            ${gawk}/bin/awk '/^\[/{if(flag){print "NoDisplay=true"} flag=0} /^\[Desktop Entry\]$/ { flag=1 } { print } END {if(flag) print "NoDisplay=true"}' \
            ${package}/share/applications/$name.desktop > $out/share/applications/$name.desktop
          done
        fi
      '');
in {
  options.aris.daw = {
    enable = lib.mkEnableOption "daw";
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs.unstable; [
      ardour
      vital
      yoshimi
      lsp-plugins
      (hideDesktopEntry lsp-plugins [])
    ];
  };
}
