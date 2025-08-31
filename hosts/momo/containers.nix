{ config, lib, pkgs, ... }:

{
  virtualisation.oci-containers.containers.memo = {
    volumes = [ "/files/memos/:/var/opt/memos" ];
    ports = [ "5230:5230" ];
    image = "neosmemo/memos:stable";
  };

  virtualisation.oci-containers.containers.transmission = {
    volumes = [
      "/files/media/transmission/data:/config"
      "/files/media/transmission/Downloads:/downloads"
    ];
    image = "lscr.io/linuxserver/transmission:latest";
    environment = {
      PUID = "2005";
      GUID = "2005";
      TZ = "America/Sao_Paulo";
    };
    ports = [ "9091:9091" "51413:51413" "51413:51413/udp" ];
  };

  environment.etc."transmission/settings.json" = {
    uid = 2005;
    gid = 2005;
    enable = true;
    text = ''
      {
        "alt-speed-down": 524,
        "alt-speed-enabled": false,
        "alt-speed-time-begin": 540,
        "alt-speed-time-day": 127,
        "alt-speed-time-enabled": false,
        "alt-speed-time-end": 1020,
        "alt-speed-up": 100,
        "announce-ip": "",
        "announce-ip-enabled": false,
        "anti-brute-force-enabled": false,
        "anti-brute-force-threshold": 100,
        "bind-address-ipv4": "0.0.0.0",
        "bind-address-ipv6": "::",
        "blocklist-enabled": false,
        "blocklist-url": "http://www.example.com/blocklist",
        "cache-size-mb": 4,
        "default-trackers": "",
        "dht-enabled": true,
        "download-dir": "/downloads/complete",
        "download-queue-enabled": true,
        "download-queue-size": 5,
        "encryption": 1,
        "idle-seeding-limit": 30,
        "idle-seeding-limit-enabled": false,
        "incomplete-dir": "/downloads/incomplete",
        "incomplete-dir-enabled": true,
        "lpd-enabled": false,
        "message-level": 2,
        "peer-congestion-algorithm": "",
        "peer-id-ttl-hours": 6,
        "peer-limit-global": 2000,
        "peer-limit-per-torrent": 100,
        "peer-port": 51413,
        "peer-port-random-high": 65535,
        "peer-port-random-low": 49152,
        "peer-port-random-on-start": false,
        "peer-socket-tos": "le",
        "pex-enabled": true,
        "port-forwarding-enabled": true,
        "preallocation": 1,
        "prefetch-enabled": true,
        "queue-stalled-enabled": true,
        "queue-stalled-minutes": 30,
        "ratio-limit": 4,
        "ratio-limit-enabled": true,
        "rename-partial-files": true,
        "rpc-authentication-required": false,
        "rpc-bind-address": "0.0.0.0",
        "rpc-enabled": true,
        "rpc-host-whitelist": "127.0.0.1",
        "rpc-host-whitelist-enabled": false,
        "rpc-password": "{1ddd3f1f6a71d655cde7767242a23a575b44c909n5YuRT.f",
        "rpc-port": 9091,
        "rpc-socket-mode": "0750",
        "rpc-url": "/transmission/",
        "rpc-username": "",
        "rpc-whitelist": "127.0.0.1,192.168.133.*",
        "rpc-whitelist-enabled": true,
        "scrape-paused-torrents-enabled": true,
        "script-torrent-added-enabled": false,
        "script-torrent-added-filename": "",
        "script-torrent-done-enabled": false,
        "script-torrent-done-filename": "",
        "script-torrent-done-seeding-enabled": false,
        "script-torrent-done-seeding-filename": "",
        "seed-queue-enabled": false,
        "seed-queue-size": 10,
        "speed-limit-down": 524,
        "speed-limit-down-enabled": false,
        "speed-limit-up": 100,
        "speed-limit-up-enabled": false,
        "start-added-torrents": true,
        "tcp-enabled": true,
        "torrent-added-verify-mode": "fast",
        "trash-original-torrent-files": false,
        "umask": "002",
        "upload-slots-per-torrent": 14,
        "utp-enabled": false,
        "watch-dir": "/watch",
        "watch-dir-enabled": true
      }
    '';
  };

  networking.firewall.allowedTCPPorts = [ 9091 51413 5230 ];
  networking.firewall.allowedUDPPorts = [ 51413 ];
}
