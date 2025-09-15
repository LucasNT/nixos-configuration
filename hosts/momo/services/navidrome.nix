{ config, lib, pkgs, ... }: {
  services.navidrome = {
    user = "lucas";
    group = "media";
    openFirewall = true;
    enable = true;
    settings = {
      Address = "0.0.0.0";
      MusicFolder = "/files/Lucas/NAS/Músicas";
      DataFolder = "/files/media/navidrome-data";
      LogLevel = "debug";
      EnableInsightsCollector = false;
    };
  };

}
