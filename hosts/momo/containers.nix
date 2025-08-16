{ config, lib, pkgs, ... }:

{
  virtualisation.oci-containers.containers.momo = {
    volumes = [ "/files/memos/:/var/opt/memos" ];
    ports = [ "5230:5230" ];
    image = "neosmemo/memos:stable";
  };
}
