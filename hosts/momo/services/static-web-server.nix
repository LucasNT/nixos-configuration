{ config, lib, pkgs, ... }:

{
  services.static-web-server = {
    enable = true;
    root = "/files/media/jogos";
    configuration = {
      general = {
        port = 8787;
        compression = true;
        compression-level = "default";
        directory-listing = true;
      };
    };
  };

}
