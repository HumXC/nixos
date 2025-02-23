let
    settings = (
        (import ./vscode.nix)//
        (import ./language.nix)//
        (import ./extensions.nix)
    );
in settings