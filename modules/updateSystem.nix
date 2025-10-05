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
        OnCalendar = "00 10 * * 0,3,6";
        Persistent = true;
        Unit = "update-system";
      };
    };

    systemd.services."update-system" = {
      script = ''
        set -eu
        ${pkgs.coreutils}/bin/sleep 60
        ${pkgs.libnotify}/bin/notify-send -u normal "Nix Rebuild Started"
        if ${pkgs.nixos-rebuild}/bin/nixos-rebuild --flake git://github.com/LucasNT/nixos-configuration:main --verbose boot; then
            ${pkgs.libnotify}/bin/notify-send -u normal "Nix Rebuild Succed"
        else
            ${pkgs.libnotify}/bin/notify-send -u critical "Nix Rebuild Failed"
        fi
      '';
      serviceConfig = {
        Type = "oneshot";
        User = "root";
      };
    };
  };
}
