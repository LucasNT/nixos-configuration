{ config, lib, pkgs, ... }:

{
  services.TorrentHelperBot = {
    enable = true;
    allowedUsers = ["335819039" "1017922169"];
    telegramBotTokenPath = "/var/lib/TorrentHelperBot/token";
  };
}
