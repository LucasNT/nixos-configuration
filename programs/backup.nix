{ config, lib, pkgs, extraConfig ? { } }:

{
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
}
