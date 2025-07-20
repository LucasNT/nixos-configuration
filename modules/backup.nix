{ config, lib, pkgs, ... }:
let cfg = config.LucasNT.backup;
in {

  options.LucasNT.backup = {
    enable = lib.mkEnableOption
      "Enable backup configurations, it uses the snapper software, it only works with btrfs";
    isBtrfs = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Indicate that the system uses btrfs as filesystem";
    };
  };

  config = lib.mkIf cfg.enable {
    services.snapper = {
      cleanupInterval = "1d";
      configs = {
        home = {
          SUBVOLUME = "/home";
          FSTYPE = "btrfs";
          TIMELINE_CREATE = true;
          TIMELINE_CLEANUP = true;
          TIMELINE_LIMIT_HOURLY = 50;
          TIMELINE_LIMIT_DAILY = 4;
          TIMELINE_LIMIT_WEEKLY = 0;
          TIMELINE_LIMIT_MONTHLY = 0;
          TIMELINE_LIMIT_QUARTERLY = 0;
          TIMELINE_LIMIT_YEARLY = 0;
        };
      };
    };
  };

}
