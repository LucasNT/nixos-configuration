{ config, lib, pkgs, username, ... }:

{
  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      AllowUsers = [ "${username}" ];
      PermitRootLogin = "no";
    };
  };
}
