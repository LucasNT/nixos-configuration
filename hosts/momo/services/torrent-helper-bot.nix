{ config, lib, pkgs, ... }:

{
  services.TorrentHelperBot = {
    enable = true;
    allowedUsers = ["335819039"];
    telegramBotTokenPath = "/var/lib/TorrentHelperBot/token";
  };
}
