{ config, lib, pkgs, ... }:

{
  services.redis.servers.anytype = {
    enable = true;
    appendOnly = true;
    bind = "0.0.0.0";
    port = 44265;
    openFirewal = true;
  };
}
