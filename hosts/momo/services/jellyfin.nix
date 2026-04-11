{pkgs, ...} :
{
  services.jellyfin = {
    enable = true;
    group = "media";
    user = "jellyfin";
    openFirewall = true;
    logDir = "/files/media/config/log";
    configDir = "/files/media/config/config";
    dataDir = "/files/media/config/data";
    cacheDir = "/files/media/config/cache";
  };
  environment.systemPackages = [
    pkgs.jellyfin
    pkgs.jellyfin-web
    pkgs.jellyfin-ffmpeg
  ];
}
