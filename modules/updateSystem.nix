{ config, lib, pkgs, ... }:
let cfg = config.LucasNT.update;
in {
  imports = [ ];
  options.LucasNT.update = {
    enable = lib.mkEnableOption "enable cron to update system";
  };
  config = lib.mkIf cfg.enable {
    systemd.timers."update-system" = {
      timerConfig = {
        OnCalendar = "Mon,Wed,Fri,Sun *-*-* 10:00:00";
        Persistent = true;
      };
    };

    systemd.services."update-system" = {
      script = ''
        set -eu
        ${pkgs.coreutils}/bin/sleep 60
        ${pkgs.coreutils}/bin/echo "Nix Rebuild Started"
        if ${pkgs.nixos-rebuild}/bin/nixos-rebuild --flake github:LucasNT/nixos-configuration --verbose boot; then
            ${pkgs.coreutils}/bin/echo "Nix Rebuild Succed"
        else
            ${pkgs.coreutils}/bin/echo "Nix Rebuild Failed"
        fi
      '';
      serviceConfig = {
        Type = "oneshot";
        User = "root";
      };
    };
  };
}
