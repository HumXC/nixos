pkgs: {
  misans = pkgs.callPackage ./misans { };
  hmcl-bin = pkgs.callPackage ./hmcl-bin { };
  qq = pkgs.callPackage ./qq { };
  fluent-cursors-theme = pkgs.callPackage ./fluent-cursors-theme { };
  orchis-gtk = pkgs.callPackage ./orchis-gtk { };
  fcitx5-mellow-themes = pkgs.callPackage ./fcitx5-mellow-themes { };
}
