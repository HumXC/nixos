{pkgs, ...}: let
  hugo-new-content = pkgs.writeScriptBin "hugo-new-content" ''
    name=post/$*
    if [[ $name == *" "* ]]; then
      echo "Error: The name contains spaces!"
      exit 1
    fi
    mkdir "content/$name"
    ${pkgs.hugo}/bin/hugo new content "$name/index.md"
  '';
  hugo-server = pkgs.writeScriptBin "hugo-server" ''${pkgs.hugo}/bin/hugo server -D'';
in
  pkgs.mkShell {
    buildInputs = [
      pkgs.hugo
      pkgs.go
      hugo-new-content
      hugo-server
    ];
    shellHook = ''
      echo "hugo-new-content <name> : create a new post"
      echo "hugo-server : start a hugo server with \"-D\""
    '';
  }
