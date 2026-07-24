{ config, lib, pkgs, ... }:

{
  networking.firewall.allowedTCPPorts = [ 64265 ];
  services.redis.servers.anytype = {
    enable = true;
    appendOnly = true;
    bind = "192.168.135.10";
    port = 64265;
    settings. dir = lib.mkForce "/files/application/redis/anytype";
  };
}
