{ config, lib, pkgs, ... }:

{
  services.traefik = {
    enable = true;
    staticConfigOptions = {
      entryPoints = {
        web = {
          address = ":80";
          asDefault = true;
        };
      };
    };
    dynamicConfigOptions = {
      http.routers = {
        memos = {
          rule = "Host(`notas.lucasnt.dev`)";
          service = "memos";
          entryPoints = [ "web" ];
        };
        transmission = {
          rule = "Host(`transmission.lucasnt.dev`)";
          service = "transmission";
          entryPoints = [ "web" ];
        };
        navidrome = {
          rule = "Host(`navidrome.lucasnt.dev`)";
          service = "navidrome";
          entryPoints = [ "web" ];
        };
        alloy = {
          rule = "Host(`alloy.lucasnt.dev`)";
          service = "alloy";
          entryPoints = [ "web" ];
        };
      };
      http.serversTransports = { insecureTransport.insecureSkipVerify = true; };
      http.services = {
        transmission = {
          loadBalancer = { servers.uri = [ "http://localhost:9091" ]; };
        };
        navidrome = {
          loadBalancer = { servers.uri = [ "http://localhost:4533" ]; };
        };
        memos = {
          loadBalancer = { servers.uri = [ "http://localhost:5230" ]; };
        };
        alloy = {
          loadBalancer = { servers.uri = [ "http://localhost:123456" ]; };
        };
      };
    };
    log = {
      filePath = "/var/log/traefik.log";
      level = "INFO";
      maxBackups = 2;
      compress = true;
    };
    accessLog = { filePath = "/var/log/traefik_access.log"; };
  };

  services.logrotate.enable = true;
  services.logrotate.settings."/var/log/traefik_access.log" = {
    frequency = "daily";
    rotate = 3;
  };
}
