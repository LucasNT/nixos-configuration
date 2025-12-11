{ config, lib, pkgs, ... }:

{
  services.static-web-server = {
    enable = true;
    root = "/files/media/jogos";
  };

}
