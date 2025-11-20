{ config, lib, pkgs, ... }:
let cfg = config.LucasNT.update;
in {
  imports = [ ];
  options.LucasNT.update = {
    enable = lib.mkEnableOption "enable cron to update system";
    OnCalendar = lib.mkOption {
      type = lib.types.string;
      default = "Mon,Wed,Fri,Sun *-*-* 10:00:00";
      description = "Set time to update system";
    };
    resetPcOnSuccessUpdate =
      lib.mkEnableOption "enable reset after success rebuild";
  };
  config = lib.mkIf cfg.enable {
    systemd.timers."update-system" = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = cfg.OnCalendar;
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
            if [ "${toString cfg.resetPcOnSuccessUpdate}" ]  ; then
              reboot
            fi
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
