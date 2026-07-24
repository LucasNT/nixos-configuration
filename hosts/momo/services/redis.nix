{ config, lib, pkgs, ... }:

{
  networking.firewall.allowedTCPPorts = [ 64265 ];
  services.redis.servers.anytype = {
    enable = true;
    appendOnly = true;
    bind = "0.0.0.0";
    port = 44265;
    settings. dir = lib.mkForce "/files/application/redis/anytype";
  };
}
