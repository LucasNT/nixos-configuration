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
      "/files/media/transmission/Dowloads:/downloads"
    ];
    image = "lscr.io/linuxserver/transmission:latest";
    environment = {
      PUID = 2005;
      GUID = 2005;
      TZ = "America/Sao_Paulo";
    };
    ports = [ "9091:9091" "51413:51413" "51413:51413/udp" ];
  };

  networking.firewall.allowedTCPPorts = [ 9091 51413 5230 ];
  networking.firewall.allowedUDPPorts = [ 51413 ];
}
