{ config, lib, pkgs, ... }:

{
  networking.firewall.allowedTCPPorts = [ 27017 ];
  services.mongodb = {
    enable = true;
    bind_ip = "0.0.0.0";
    dbpath = "/files/application/mongodb";
    enableAuth = true;
    initialScript = /home/mongoInitialScript;
    initialRootPasswordFile = /home/mongoPassword;
    package = pkgs.mongodb-ce;
  };
}
