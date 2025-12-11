{ config, lib, pkgs, ... }:

{
  services.static-web-server = {
    enable = true;
    configuration = {
      general = {
        port = 8787;
        root = "/files/media/jogos";
        compression = true;
        compression-level = "default";
        directory-listing = true;
      };
    };
  };

}
