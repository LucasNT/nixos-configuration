{ config, lib, pkgs, ... }:

{
  virtualisation.oci-containers.containers.copyparty = {
    volumes = [ "/files/Lucas:/w" ];
    ports = [ "3923:3923" ];
    image = "copyparty/ac:latest";
  };

  networking.firewall.allowedTCPPorts = [ 3923 ];
}
