{ nixpkgs, system, lib, cfg, ... }:
let
  overlays = self: super: {
    lemurs = super.lemurs.overrideAttrs (oldAttrs: {
      postInstall = ''
        cp -r $src/extra $out/extra
      '' + (oldAttrs.postInstall or "");
    });
  };
  pkgs = import nixpkgs { overlays = [ overlays ]; system = system; };
  lemurs = pkgs.lemurs;
in
{
  options.os.programs.lemurs.enable = lib.mkEnableOption "lemurs";
  config = lib.mkIf cfg.enable {
    environment = {
      systemPackages = [
        pkgs.lemurs
      ];
      etc = {
        "lemurs/config.toml".source = "${lemurs}/extra/config.toml";
        "lemurs/xsetup.sh".source = "${lemurs}/extra/xsetup.sh";
        "pam.d/lemurs".source = "${lemurs}/extra/lemurs.pam";
        "lemurs/wayland/Hyprland".text = ''
          #!/usr/bin/env bash
          exec Hyprland
        '';
      };
    };
    security.pam = {
      u2f.enable = true;
    };

    systemd.services.lemurs = {
      enable = true;
      description = "Lemurs";
      after = [
        "systemd-user-sessions.service"
        "getty@tty2.service"
      ];
      # wantedBy = [ "display-manager.service" ];
      aliases = [ "display-manager.service" ];
      serviceConfig = {
        ExecStart = "${lemurs}/bin/lemurs";
        StandardInput = "tty";
        TTYPath = "/dev/tty2";
        TTYReset = "yes";
        TTYVHangup = "yes";
        Type = "idle";
      };
    };
  };
}
