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
          rule = "Host(`notas.local`)";
          service = "memos";
          entryPoints = [ "web" ];
        };
        transmission = {
          rule = "Host(`transmission.local`)";
          service = "transmission";
          entryPoints = [ "web" ];
        };
        navidrome = {
          rule = "Host(`navidrome.local`)";
          service = "navidrome";
          entryPoints = [ "web" ];
        };
        alloy = {
          rule = "Host(`alloy.local`)";
          service = "alloy";
          entryPoints = [ "web" ];
        };
        api = {
          rule = "Host(`192.168.189.10`)";
          service = "api@internal";
          entryPoints = [ "web" ];
        };
        jogos = {
          rule = "Host(`games.local`)";
          service = "jogos";
          entryPoints = [ "web" ];
        };
        jellyfin = {
          rule = "Host(`streamer.local`)";
          service = "jellyfin";
          entryPoints = [ "web" ];
        };
        proxmox = {
          rule = "Host(`proxmox.local`)";
          service = "proxmox";
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
        jogos = {
          loadBalancer = { servers = [{ url = "http://localhost:8787"; }]; };
        };
        jellyfin = {
          loadBalancer = {
            servers = [{ url = "http://192.168.189.82:8096"; }];
          };
        };
        proxmox = {
          loadBalancer = {
            servers = [{ url = "http://192.168.189.5:8006"; }];
          };
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
