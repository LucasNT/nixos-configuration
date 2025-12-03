{ config, lib, pkgs, ... }:

{
  networking.firewall.allowedTCPPorts = [ 80 ];
  services.traefik = {
    enable = true;
    staticConfigOptions = {
      entryPoints = {
        web = {
          address = ":80";
          asDefault = true;
        };
        websecure = { address = ":443"; };
      };
      log = {
        filePath = "${config.services.traefik.dataDir}/traefik.log";
        level = "INFO";
        maxBackups = 2;
        compress = true;
      };
      accessLog = {
        filePath = "${config.services.traefik.dataDir}/traefik_access.log";
      };
      api = { };
    };
    dynamicConfigOptions = {
      http.routers = {
        memos = {
          rule = "Host(`notas.lucasnt.dev`)";
          service = "memos";
          entryPoints = [ "websecure" ];
        };
        transmission = {
          rule = "Host(`transmission.lucasnt.dev`)";
          service = "transmission";
          entryPoints = [ "websecure" ];
        };
        navidrome = {
          rule = "Host(`navidrome.lucasnt.dev`)";
          service = "navidrome";
          entryPoints = [ "websecure" ];
        };
        alloy = {
          rule = "Host(`alloy.lucasnt.dev`)";
          service = "alloy";
          entryPoints = [ "websecure" ];
        };
        api = {
          rule = "Host(`192.168.189.10`)";
          service = "api@internal";
          entryPoints = [ "web" ];
        };
      };
      http.serversTransports = { insecureTransport.insecureSkipVerify = true; };
      http.services = {
        transmission = {
          loadBalancer = { servers = [{ url = "http://localhost:9091"; }]; };
        };
        navidrome = {
          loadBalancer = { servers = [{ url = "http://localhost:4533"; }]; };
        };
        memos = {
          loadBalancer = { servers = [{ url = "http://localhost:5230"; }]; };
        };
        alloy = {
          loadBalancer = { servers = [{ url = "http://localhost:123456"; }]; };
        };
      };
    };
  };

  services.logrotate.enable = true;
  services.logrotate.settings."${config.services.traefik.dataDir}/traefik_access.log" =
    {
      frequency = "daily";
      rotate = 3;
    };
}
